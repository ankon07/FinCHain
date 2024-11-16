import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class BankOrCardInfo extends StatelessWidget {
  final String name;
  final String number;
  final String imageUrl;

  const BankOrCardInfo(
      {super.key,
      required this.name,
      required this.number,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Container(
      width: double.infinity,
      color: theme.canvasColor,
      margin: EdgeInsets.symmetric(
        vertical: heightFactor * 4,
        horizontal: widthFactor * 8,
      ),
      padding: EdgeInsets.symmetric(
        vertical: heightFactor * 5,
        horizontal: widthFactor * 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: widthFactor * 50,
            height: widthFactor * 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primaryColor,
                width: 1,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: widthFactor * 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: widthFactor * 16,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              Text(
                number,
                style: TextStyle(
                  fontSize: widthFactor * 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
