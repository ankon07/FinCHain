import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/bottom_navbar.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  final User user;
  final String? title;

  const ComingSoon({
    super.key,
    required this.user,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: FinchainAppBar(
        title: title ?? "Coming Soon",
        backButtonExists: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(heightFactor * 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch_rounded,
              size: heightFactor * 100,
              color: theme.primaryColor,
            ),
            SizedBox(height: heightFactor * 30),
            Text(
              "Coming Soon!",
              style: TextStyle(
                fontSize: heightFactor * 24,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: heightFactor * 20),
            Text(
              "This feature is under development and will be available soon.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: heightFactor * 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: heightFactor * 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(
                      user: user,
                    ),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: heightFactor * 30,
                  vertical: heightFactor * 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Back to Home",
                style: TextStyle(
                  fontSize: heightFactor * 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
