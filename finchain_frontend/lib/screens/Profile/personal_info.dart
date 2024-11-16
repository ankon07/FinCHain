import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class PersonalInfo extends StatelessWidget {
  final User user;

  const PersonalInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;
    double fontSize = widthFactor * 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal info",
          style: TextStyle(
            fontSize: widthFactor * 20,
            fontWeight: FontWeight.w500,
            color: theme.secondaryHeaderColor,
            decoration: TextDecoration.underline,
          ),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heightFactor * 8),
                Text(
                  "Name:",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: theme.secondaryHeaderColor,
                  ),
                ),
                SizedBox(height: heightFactor * 8),
                Text(
                  "E-mail:",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: theme.secondaryHeaderColor,
                  ),
                ),
                SizedBox(height: heightFactor * 8),
                Text(
                  "Phone:",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: theme.secondaryHeaderColor,
                  ),
                ),
                SizedBox(height: heightFactor * 8),
              ],
            ),
            SizedBox(width: widthFactor * 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heightFactor * 8),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: heightFactor * 8),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: heightFactor * 8),
                Text(
                  user.contact,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: heightFactor * 8),
              ],
            ),
          ],
        )
      ],
    );
  }
}
