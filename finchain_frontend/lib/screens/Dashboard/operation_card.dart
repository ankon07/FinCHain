import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class OperationCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;
  final double fontSize;

  const OperationCard(
      {super.key,
      required this.imageUrl,
      required this.label,
      required this.onTap,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widthFactor * 109,
        height: heightFactor * 74,
        decoration: BoxDecoration(
          color: theme.dialogBackgroundColor,
          border: Border.all(color: theme.primaryColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(widthFactor * 15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: widthFactor * 109,
              height: heightFactor * 28,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(widthFactor * 15)),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widthFactor * 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: heightFactor * 5),
            SvgWidget(
              imageUrl: imageUrl,
              label: label,
              width: widthFactor * 30,
              height: widthFactor * 30,
            )
          ],
        ),
      ),
    );
  }
}
