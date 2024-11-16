import 'package:finchain_frontend/models/Account/account.dart';

class BankAccount {
  final String bankName;
  final List<Account> accounts;

  BankAccount({
    required this.bankName,
    required this.accounts,
  });
}
