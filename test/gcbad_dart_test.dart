@Timeout(Duration(minutes: 1))
library;

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:test/test.dart';

import 'sandbox_client.dart';

void main() {
  group('GCBAD use cases', () {
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

    test('Get account details', () async {
      var accounts = await client.getAccounts(requisition);
      expect(accounts.length, 2);

      var details = await client.getAccountDetails(accounts[0]);

      expect(details.account.resourceId, '01F3NS4YV94RA29YCH8R0F6BMF');
      expect(details.account.iban, matches(r'GL[0-9]{16}'));
      expect(details.account.currency, 'EUR');
      expect(details.account.ownerName, 'John Doe');
      expect(details.account.name, 'Main Account');
      expect(details.account.product, 'Checkings');
      expect(details.account.cashAccountType, 'CACC');

      details = await client.getAccountDetails(accounts[1]);

      expect(details.account.resourceId, '01F3NS5ASCNMVCTEJDT0G215YE');
      expect(details.account.iban, matches(r'GL[0-9]{16}'));
      expect(details.account.currency, 'EUR');
      expect(details.account.ownerName, 'Jane Doe');
      expect(details.account.name, 'Main Account');
      expect(details.account.product, 'Checkings');
      expect(details.account.cashAccountType, 'CACC');
    });

    test('Get transactions', () async {
      var accounts = await client.getAccounts(requisition);
      expect(accounts.length, 2);

      var transactions = await client.getTransactions(accounts[0],
          dateFrom: DateTime(2023, 11, 26), dateTo: DateTime(2023, 11, 28));

      expect(transactions.transactions.booked, isNotEmpty);
    });
  });
}
