import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class AddMoneyCard extends StatefulWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onPressed;

  const AddMoneyCard({
    super.key,
    required this.label,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  State<AddMoneyCard> createState() => _AddMoneyCardState();
}

class _AddMoneyCardState extends State<AddMoneyCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    double heightFactor = screenHeight / 926;

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        margin: EdgeInsets.all(heightFactor * 5),
        padding: EdgeInsets.symmetric(
          vertical: heightFactor * 5,
          horizontal: heightFactor * 14,
        ),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: theme.primaryColor),
                borderRadius: BorderRadius.circular(35),
              ),
              child: CircleAvatar(
                radius: heightFactor * 17,
                backgroundColor: theme.dialogBackgroundColor,
                child: SvgWidget(
                  imageUrl: widget.imageUrl,
                  width: heightFactor * 15,
                  height: heightFactor * 15,
                ),
              ),
            ),
            SizedBox(width: heightFactor * 10),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: heightFactor * 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
