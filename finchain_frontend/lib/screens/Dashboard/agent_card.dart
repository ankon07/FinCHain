import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class AgentCard extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const AgentCard({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Container(
      height: heightFactor * 57,
      margin: EdgeInsets.all(widthFactor * 8),
      padding: EdgeInsets.all(widthFactor * 8),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
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
                imageUrl: "assets/icons/agent_store.svg",
                width: widthFactor * 15,
                height: widthFactor * 15,
              ),
            ),
          ),
          SizedBox(width: widthFactor * 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: widthFactor * 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Text(
                  "See Location",
                  style: TextStyle(
                    fontSize: widthFactor * 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
