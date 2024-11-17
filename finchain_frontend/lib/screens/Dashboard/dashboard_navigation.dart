import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Add-Money/add_money.dart';
import 'package:finchain_frontend/screens/Cash-Out/cash_out.dart';
import 'package:finchain_frontend/screens/Payment/payment.dart';
import 'package:finchain_frontend/screens/Send-Money/send_money.dart';
import 'package:flutter/material.dart';

class DashboardNavigation {
  DashboardNavigation._privateConstructor();

  static final DashboardNavigation instance =
      DashboardNavigation._privateConstructor();

  void navigateToSendMoney({
    required BuildContext context,
    required User user,
    required String balance,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendMoney(
          user: user,
          balance: balance,
        ),
      ),
    );
  }

  void navigateToAddMoney({
    required BuildContext context,
    required User user,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMoney(user: user),
      ),
    );
  }

  void navigateToCashOut({
    required BuildContext context,
    required User user,
    required String balance,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CashOut(
          user: user,
          balance: balance,
        ),
      ),
    );
  }

  void navigateToPayment({
    required BuildContext context,
    required User user,
    required String balance,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Payment(
          user: user,
          balance: balance,
        ),
      ),
    );
  }
}
