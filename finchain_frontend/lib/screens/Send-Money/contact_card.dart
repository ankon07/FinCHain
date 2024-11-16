import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatefulWidget {
  final Contact contact;
  final VoidCallback? buttonAction;

  const ContactCard({
    super.key,
    required this.contact,
    this.buttonAction,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return GestureDetector(
      onTap: widget.buttonAction,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          vertical: heightFactor * 4,
          horizontal: heightFactor * 8,
        ),
        padding: EdgeInsets.symmetric(
          vertical: heightFactor * 5,
          horizontal: heightFactor * 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: theme.primaryColor),
                borderRadius: BorderRadius.circular(widthFactor * 35),
              ),
              child: CircleAvatar(
                radius: widthFactor * 25,
                backgroundColor: theme.dialogBackgroundColor,
                child: SvgWidget(
                  imageUrl: "assets/icons/person.svg",
                  width: widthFactor * 23,
                  height: widthFactor * 23,
                ),
              ),
            ),
            SizedBox(width: widthFactor * 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  style: TextStyle(
                    fontSize: widthFactor * 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.contact.number,
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
      ),
    );
  }
}
