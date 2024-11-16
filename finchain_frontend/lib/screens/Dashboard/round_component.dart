import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class RoundComponent extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  const RoundComponent({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.onTap,
  });

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: theme.primaryColor),
                borderRadius: BorderRadius.circular(widthFactor * 35)),
            child: CircleAvatar(
              radius: widthFactor * 17,
              backgroundColor: theme.dialogBackgroundColor,
              child: SvgWidget(
                imageUrl: imageUrl,
                width: widthFactor * 15,
                height: widthFactor * 15,
              ),
            ),
          ),
          SizedBox(height: heightFactor * 1),
          Text(
            label,
            style: TextStyle(
              fontSize: widthFactor * 8,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
