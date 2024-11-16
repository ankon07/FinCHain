import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Add-Money/add_money.dart';
import 'package:finchain_frontend/screens/Send-Money/send_money.dart';
import 'package:flutter/material.dart';

class DashboardNavigation {
  DashboardNavigation._privateConstructor();

  static final DashboardNavigation instance =
      DashboardNavigation._privateConstructor();

  void navigateToSendMoney(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendMoney(user: user),
      ),
    );
  }

  void navigateToAddMoney(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMoney(user: user),
      ),
    );
  }
}
