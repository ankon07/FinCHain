import 'package:finchain_frontend/screens/Transaction-History/transaction_history.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

void showTransactionDetailsModal({
  required BuildContext context,
  required Transaction transaction,
  required String title,
  required String formattedTimestamp,
  required String userMobile,
}) {
  final theme = AppTheme.getTheme();
  final screenSize = MediaQuery.of(context).size;
  final screenWidth = screenSize.width;
  double widthFactor = screenWidth / 428;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      bool isIncoming = transaction.receiverMobile == userMobile;
      return Container(
        height: screenSize.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(widthFactor * 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: widthFactor * 10),
              width: widthFactor * 40,
              height: widthFactor * 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(widthFactor * 2),
              ),
            ),
            // Transaction Status
            Container(
              padding: EdgeInsets.all(widthFactor * 15),
              child: Column(
                children: [
                  Icon(
                    isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncoming ? Colors.green : Colors.orange,
                    size: widthFactor * 40,
                  ),
                  SizedBox(height: widthFactor * 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: widthFactor * 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  SizedBox(height: widthFactor * 5),
                  Text(
                    "${transaction.amount} BDT",
                    style: TextStyle(
                      fontSize: widthFactor * 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: theme.primaryColor.withOpacity(0.2)),
            // Transaction Details
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(widthFactor * 20),
                child: Column(
                  children: [
                    _buildDetailItem(
                      "Status",
                      "Completed",
                      Icons.check_circle,
                      Colors.green,
                      widthFactor,
                    ),
                    _buildDetailItem(
                      "Date & Time",
                      formattedTimestamp,
                      Icons.access_time,
                      theme.primaryColor,
                      widthFactor,
                    ),
                    _buildDetailItem(
                      isIncoming ? "From" : "To",
                      isIncoming ? transaction.senderMobile! : transaction.receiverMobile!,
                      Icons.person,
                      theme.primaryColor,
                      widthFactor,
                    ),
                    if (transaction.fee.isNotEmpty)
                      _buildDetailItem(
                        "Transaction Fee",
                        "${transaction.fee} BDT",
                        Icons.payment,
                        theme.primaryColor,
                        widthFactor,
                      ),
                    if (transaction.memo != null && transaction.memo!.isNotEmpty)
                      _buildDetailItem(
                        "Reference",
                        transaction.memo!,
                        Icons.description,
                        theme.primaryColor,
                        widthFactor,
                      ),
                  ],
                ),
              ),
            ),
            // Close Button
            Padding(
              padding: EdgeInsets.all(widthFactor * 20),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  minimumSize: Size(double.infinity, widthFactor * 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widthFactor * 10),
                  ),
                ),
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: widthFactor * 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildDetailItem(
  String title,
  String value,
  IconData icon,
  Color iconColor,
  double widthFactor,
) {
  return Container(
    margin: EdgeInsets.only(bottom: widthFactor * 15),
    child: Row(
      children: [
        Icon(icon, color: iconColor, size: widthFactor * 24),
        SizedBox(width: widthFactor * 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: widthFactor * 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: widthFactor * 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: widthFactor * 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
