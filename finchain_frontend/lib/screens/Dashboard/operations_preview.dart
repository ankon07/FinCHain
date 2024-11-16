import 'package:finchain_frontend/screens/Dashboard/dashboard_navigation.dart';
import 'package:finchain_frontend/screens/Dashboard/operation_card.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:flutter/material.dart';

class OperationsPreview extends StatefulWidget {
  final User user;

  const OperationsPreview({super.key, required this.user});

  @override
  State<OperationsPreview> createState() => _OperationsPreviewState();
}

class _OperationsPreviewState extends State<OperationsPreview> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthFactor * 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OperationCard(
                imageUrl: "assets/icons/send_money.svg",
                label: "Send Money",
                onTap: () => DashboardNavigation.instance
                    .navigateToSendMoney(context, widget.user),
                fontSize: 14 * widthFactor,
              ),
              OperationCard(
                imageUrl: "assets/icons/mobile_recharge.svg",
                label: "Mobile Recharge",
                onTap: () => DashboardNavigation.instance
                    .navigateToSendMoney(context, widget.user),
                fontSize: 14 * widthFactor,
              ),
              OperationCard(
                imageUrl: "assets/icons/cash_out.svg",
                label: "Cash Out",
                onTap: () => DashboardNavigation.instance
                    .navigateToSendMoney(context, widget.user),
                fontSize: 14 * widthFactor,
              ),
            ],
          ),
          SizedBox(height: heightFactor * 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OperationCard(
                imageUrl: "assets/icons/add_money.svg",
                label: "Add Money",
                onTap: () => DashboardNavigation.instance
                    .navigateToAddMoney(context, widget.user),
                fontSize: 14 * widthFactor,
              ),
              OperationCard(
                imageUrl: "assets/icons/bank_transfer.svg",
                label: "Bank Transfer",
                onTap: () => DashboardNavigation.instance
                    .navigateToSendMoney(context, widget.user),
                fontSize: 14 * widthFactor,
              ),
              OperationCard(
                imageUrl: "assets/icons/payment.svg",
                label: "Payment",
                onTap: () => DashboardNavigation.instance
                    .navigateToSendMoney(context, widget.user),
                fontSize: 14 * widthFactor,
              ),
            ],
          )
        ],
      ),
    );
  }
}
