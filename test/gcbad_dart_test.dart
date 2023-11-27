import 'dart:convert';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/models/requisition.dart';
import 'package:test/test.dart';

import 'sandbox_client.dart';

void main() {
  group('A group of tests', () {
    late GoCardlessBankAccountDataClient client;
    late Requisition requisition;

    setUp(() async {
      (client, requisition) = await SandboxClient().waitForRequisition();
    });

    test('Get accounts', () async {
      var accounts = await client.getAccounts(requisition);

      expect(accounts.length, 2);
      expect(accounts[0].ownerName, 'John Doe');
      expect(accounts[1].ownerName, 'Jane Doe');

      accounts = await client.getAccountsById(requisition.id);

      expect(accounts.length, 2);
      expect(accounts[0].ownerName, 'John Doe');
      expect(accounts[1].ownerName, 'Jane Doe');

      for (var account in accounts) {
        var queriedAccount = await client.getAccountById(account.id);
        expect(queriedAccount.toJson(), account.toJson());
      }
    });

    test('Get balances', () async {
      var accounts = await client.getAccounts(requisition);

      for (var account in accounts) {
        var balances = await client.getBalances(account);

        expect(balances.balances.length, 2);
        expect(balances.balances[0].balanceAmount.amount, '1913.12');
        expect(balances.balances[0].balanceAmount.currency, 'EUR');
        expect(balances.balances[1].balanceAmount.amount, '1913.12');
        expect(balances.balances[1].balanceAmount.currency, 'EUR');

        balances = await client.getBalancesById(account.id);

        expect(balances.balances.length, 2);
        expect(balances.balances[0].balanceAmount.amount, '1913.12');
        expect(balances.balances[0].balanceAmount.currency, 'EUR');
        expect(balances.balances[1].balanceAmount.amount, '1913.12');
        expect(balances.balances[1].balanceAmount.currency, 'EUR');
      }
    });
  });
}
