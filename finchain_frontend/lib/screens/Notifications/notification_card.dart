import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/screens/Notifications/notifications.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final NotificationType notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Padding(
      padding: EdgeInsets.all(widthFactor * 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: widthFactor * 5,
              right: widthFactor * 5,
              bottom: widthFactor * 5,
              top: 0,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: theme.primaryColor),
              borderRadius: BorderRadius.circular(widthFactor * 35),
            ),
            child: CircleAvatar(
              radius: widthFactor * 28,
              backgroundColor: theme.dialogBackgroundColor,
              child: SvgWidget(
                imageUrl: notification.imageUrl,
                width: widthFactor * 27,
                height: widthFactor * 27,
              ),
            ),
          ),
          SizedBox(width: widthFactor * 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.sender,
                  style: TextStyle(
                    fontSize: widthFactor * 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: widthFactor * 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                Container(
                  margin: EdgeInsets.only(top: heightFactor * 15),
                  width: double.infinity * 0.85,
                  height: 1.0,
                  color: const Color(0xFF636262),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
