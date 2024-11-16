import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Notifications/notification_card.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class NotificationType {
  final String sender;
  final String message;
  final String imageUrl;

  NotificationType({
    required this.sender,
    required this.message,
    required this.imageUrl,
  });
}

class Notifications extends StatefulWidget {
  final User user;

  const Notifications({super.key, required this.user});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationType> notificatiions = [
    NotificationType(
      sender: "FINCHAIN",
      message: "Recharge 50 Taka and get 25 Taka cashback instantly!",
      imageUrl: "assets/icons/finchain.svg",
    ),
    NotificationType(
      sender: "Received Money",
      message: "Niaz sent you 500 taka.",
      imageUrl: "assets/icons/person.svg",
    ),
    NotificationType(
      sender: "Donation",
      message: "Thank you for donating to our charity.",
      imageUrl: "assets/icons/person.svg",
    ),
    NotificationType(
      sender: "AB Bank",
      message: "You have added 500 taka from AB Bank account.",
      imageUrl: "assets/icons/ab_bank.svg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: const FinchainAppBar(title: "Notifications"),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        margin: EdgeInsets.symmetric(
          vertical: heightFactor * 15,
          horizontal: widthFactor * 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: theme.primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: SingleChildScrollView(
          child: notificatiions.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: notificatiions
                      .map((notification) =>
                          NotificationCard(notification: notification))
                      .toList(),
                )
              : SizedBox(
                  height: screenHeight * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "No notifications yet!",
                        style: TextStyle(
                          fontSize: widthFactor * 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
