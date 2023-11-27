import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/models/requisition.dart';
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
        secretKey: Platform.environment["GCBAD_KEY"]!);

    requisitionFuture = _createRequisition();
  }

  Future<(GoCardlessBankAccountDataClient, Requisition)>
      waitForRequisition() async {
    await requisitionFuture;
    return (client, requisition);
  }

  Future _createRequisition() async {
    var institution = await client.getSandboxInstitution();
    var agreement = await client.createAgreement(institution);
    requisition = await client.createRequisition(agreement);

    var browser = await puppeteer.launch(headless: true);
    var page = await browser.newPage();

    await page.goto(requisition.link, wait: Until.networkIdle);
    await page.click(".btn-success");
    await page.waitForSelector(".btn-primary");
    await page.click(".btn-primary");
    await page.waitForSelector(".btn-primary");
    await page.click(".btn-primary");

    requisition = await client.waitForRequisitionLink(requisition);
  }
}
