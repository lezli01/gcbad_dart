import 'dart:async';
import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:puppeteer/puppeteer.dart';

/// Drives the GoCardless **sandbox** end to end: it creates an end-user
/// agreement and a requisition, then uses a headless browser to click through
/// the sandbox bank-consent flow so the requisition transitions to `linked`.
///
/// The heavy one-time bootstrap (network + browser) is shared across tests via
/// a process-wide singleton, so the consent flow runs at most once per suite.
/// Await [waitForRequisition] from a `setUpAll` and close [client] from a
/// matching `tearDownAll`.
class SandboxClient {
  static final SandboxClient _instance = SandboxClient._internal();

  factory SandboxClient() => _instance;

  late final Future<void> _requisitionFuture;

  /// The shared client. Callers own its lifecycle — close it once from a
  /// `tearDownAll`, never from an individual test (it is shared).
  late final GoCardlessBankAccountDataClient client;

  /// The linked requisition, valid only after [waitForRequisition] completes.
  late Requisition requisition;

  SandboxClient._internal() {
    final secretId = Platform.environment['GCBAD_ID'];
    final secretKey = Platform.environment['GCBAD_KEY'];
    if (secretId == null ||
        secretId.isEmpty ||
        secretKey == null ||
        secretKey.isEmpty) {
      throw StateError(
        'Set GCBAD_ID and GCBAD_KEY to run the live sandbox integration tests.',
      );
    }

    client = GoCardlessBankAccountDataClient(
      secretId: secretId,
      secretKey: secretKey,
    );

    _requisitionFuture = _createRequisition();
  }

  /// Awaits the one-time bootstrap and returns the shared [client] together
  /// with the linked [requisition].
  Future<(GoCardlessBankAccountDataClient, Requisition)>
  waitForRequisition() async {
    await _requisitionFuture;
    return (client, requisition);
  }

  Future<void> _createRequisition() async {
    final institution = await client.getSandboxInstitution();

    // transaction_total_days bounds max_historical_days; fall back defensively
    // if the sandbox ever stops reporting a numeric value so the failure is a
    // clear agreement rejection rather than an opaque parse/null-check crash.
    final maxHistoricalDays =
        int.tryParse(institution.transactionTotalDays ?? '') ?? 90;

    final agreement = await client
        .createAgreement(institution, maxHistoricalDays, 90, const [
          InformationToAccess.balances,
          InformationToAccess.details,
          InformationToAccess.transactions,
        ]);
    requisition = await client.createRequisition(agreement);

    await _approveConsent(requisition.link);

    // waitForRequisitionLink polls indefinitely; bound it so a consent flow
    // that silently failed (e.g. the requisition ends up rejected/expired)
    // fails fast with a clear message instead of hanging until the test
    // timeout.
    requisition = await client
        .waitForRequisitionLink(requisition)
        .timeout(
          const Duration(minutes: 2),
          onTimeout: () => throw TimeoutException(
            'Requisition ${requisition.id} did not reach `linked` within '
            '2 minutes; the sandbox consent flow may have failed.',
          ),
        );
  }

  /// Clicks through the sandbox consent flow in a headless browser, always
  /// closing the browser afterwards (even if a step throws).
  ///
  /// The sandbox consent flow has three steps:
  ///   1. "Agree and continue" on the GoCardless consent page (`.btn-success`)
  ///   2. "Sign in" on the Sandbox Finance bank login page (`.btn-primary`)
  ///   3. "Approve" on the consent/approve page (`.btn-primary`)
  /// Signing in kicks off a chain of OAuth redirects before the approve page
  /// loads, so we wait for that page's URL before the final click — otherwise
  /// we race the still-present "Sign in" button (also `.btn-primary`) and click
  /// a page mid-navigation. Approving transitions the requisition to `linked`.
  Future<void> _approveConsent(String link) async {
    final browser = await puppeteer.launch(
      headless: true,
      timeout: const Duration(seconds: 30),
      args: const ['--no-sandbox'],
    );

    try {
      final page = await browser.newPage();
      // Finite so a markup change surfaces as a fast, contextual failure rather
      // than a hang bounded only by the outer test timeout.
      page.defaultTimeout = const Duration(seconds: 30);

      await page.goto(link, wait: Until.networkIdle);
      await page.waitForSelector('.btn-success');
      await page.click('.btn-success');

      await page.waitForSelector('.btn-primary');
      await page.click('.btn-primary');

      final deadline = DateTime.now().add(const Duration(seconds: 30));
      while (!(page.url ?? '').contains('consent/approve')) {
        if (DateTime.now().isAfter(deadline)) {
          throw TimeoutException(
            'Consent/approve page never loaded (last url: ${page.url}).',
          );
        }
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      await page.waitForSelector('.btn-primary');
      await page.click('.btn-primary');
    } finally {
      await browser.close();
    }
  }
}
