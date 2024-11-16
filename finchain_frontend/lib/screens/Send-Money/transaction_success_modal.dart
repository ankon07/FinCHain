import 'dart:ui';

import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/screens/Send-Money/contact_card.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:finchain_frontend/utils/utils.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

void showTransactionSuccessModal(
  BuildContext context,
  Contact contact,
  double amount,
  String reference,
  DateTime currentTimestamp,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: TransactionSuccessModal(
            contact: contact,
            amount: amount,
            reference: reference,
            currentTimestamp: currentTimestamp,
          ),
        ),
      );
    },
  );
}

class TransactionSuccessModal extends StatelessWidget {
  final Contact contact;
  final double amount;
  final String reference;
  final DateTime currentTimestamp;

  const TransactionSuccessModal({
    super.key,
    required this.contact,
    required this.amount,
    required this.reference,
    required this.currentTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(heightFactor * 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: heightFactor * 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/finchain.png',
                          height: heightFactor * 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: widthFactor * 8),
                        Text(
                          "FINCHAIN",
                          style: TextStyle(
                            fontSize: heightFactor * 24,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heightFactor * 4),
                  Text(
                    "Transaction Successful",
                    style: TextStyle(
                      fontSize: heightFactor * 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(height: widthFactor * 20, color: Colors.black45),
                ],
              ),
              ContactCard(contact: contact),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTimeTextBox(
                        "Date",
                        Utils.getDateString(
                          currentTimestamp.day,
                          currentTimestamp.month,
                          currentTimestamp.year,
                        ),
                        theme,
                        heightFactor,
                      ),
                      buildTimeTextBox(
                        "Time",
                        Utils.getTimeString(
                          currentTimestamp.hour,
                          currentTimestamp.minute,
                        ),
                        theme,
                        heightFactor,
                      ),
                      buildTimeTextBox(
                        "Transaction ID",
                        "TD21379796415844",
                        theme,
                        heightFactor,
                      ),
                    ],
                  ),
                  SvgWidget(
                    imageUrl: "assets/icons/success.svg",
                    width: heightFactor * 83,
                    height: heightFactor * 83,
                  )
                ],
              ),
              SizedBox(height: heightFactor * 8),
              buildTimeTextBox(
                "Reference",
                "Bill",
                theme,
                heightFactor,
              ),
              SizedBox(height: heightFactor * 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTimeTextBox(
                        "Amount",
                        Utils.getDoubleString(amount),
                        theme,
                        heightFactor,
                      ),
                      buildTimeTextBox(
                        "Charge",
                        Utils.getDoubleString(0),
                        theme,
                        heightFactor,
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: heightFactor * 80,
                    color: Colors.black,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: heightFactor * 14,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        Utils.getDoubleString(amount),
                        style: TextStyle(
                          fontSize: heightFactor * 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FluentSystemIcons.ic_fluent_home_filled,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 5),
              const Text("Go to Home"),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTimeTextBox(
    String label,
    String value,
    ThemeData theme,
    double heightFactor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: heightFactor * 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: heightFactor * 14,
              fontWeight: FontWeight.w600,
              color: theme.secondaryHeaderColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: heightFactor * 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
