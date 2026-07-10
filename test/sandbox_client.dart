import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:puppeteer/puppeteer.dart';

class SandboxClient {
  static final SandboxClient _instance = SandboxClient._internal();

  factory SandboxClient() {
    return _instance;
  }

  late Future requisitionFuture;
  late GoCardlessBankAccountDataClient client;
  late Requisition requisition;
  bool ready = false;

  SandboxClient._internal() {
    client = GoCardlessBankAccountDataClient(
      secretId: Platform.environment["GCBAD_ID"]!,
      secretKey: Platform.environment["GCBAD_KEY"]!,
    );

    requisitionFuture = _createRequisition();
  }

  Future<(GoCardlessBankAccountDataClient, Requisition)>
  waitForRequisition() async {
    await requisitionFuture;
    return (client, requisition);
  }

  Future _createRequisition() async {
    var institution = await client.getSandboxInstitution();
    var agreement = await client.createAgreement(
      institution,
      int.parse(institution.transactionTotalDays!),
      90,
      [
        InformationToAccess.balances,
        InformationToAccess.details,
        InformationToAccess.transactions,
      ],
    );
    requisition = await client.createRequisition(agreement);

    var browser = await puppeteer.launch(
      headless: true,
      timeout: Duration(minutes: 1),
      args: ['--no-sandbox'],
    );
    var page = await browser.newPage();
    page.defaultTimeout = Duration.zero;

    // GoCardless sandbox consent flow, three steps:
    //   1. "Agree and continue" on the GoCardless consent page (.btn-success)
    //   2. "Sign in" on the Sandbox Finance bank login page (.btn-primary)
    //   3. "Approve" on the consent/approve page (.btn-primary)
    // Signing in kicks off a chain of OAuth redirects before the approve page
    // loads, so we must wait for that page before clicking — otherwise we race
    // the still-present "Sign in" button (also .btn-primary) and click a page
    // that is mid-navigation. Approving transitions the requisition to `linked`.
    await page.goto(requisition.link, wait: Until.networkIdle);
    await page.waitForSelector(".btn-success");
    await page.click(".btn-success");

    await page.waitForSelector(".btn-primary");
    await page.click(".btn-primary");

    while (!(page.url ?? "").contains("consent/approve")) {
      await Future.delayed(Duration(milliseconds: 200));
    }
    await page.waitForSelector(".btn-primary");
    await page.click(".btn-primary");

    requisition = await client.waitForRequisitionLink(requisition);
  }
}
