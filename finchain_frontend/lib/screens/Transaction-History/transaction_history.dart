import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/show_message.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction {
  final String timestamp;
  final String fee;
  final String? senderMobile;
  final String? receiverMobile;
  final String? memo;
  final String amount;

  Transaction({
    required this.timestamp,
    required this.fee,
    required this.senderMobile,
    required this.receiverMobile,
    this.memo,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      timestamp: json["timestamp"],
      fee: json["fee"],
      senderMobile: json["sender_mobile"],
      receiverMobile: json["receiver_mobile"],
      memo: json["memo"],
      amount: json["amount"],
    );
  }
}

class TransactionHistory extends StatefulWidget {
  final User user;

  const TransactionHistory({
    super.key,
    required this.user,
  });

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  ApiService apiService = ApiService();
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  Future<void> getTransactions() async {
    try {
      print("hi");
      final data = await apiService.fetchTransactions();
      print(data);
      setState(() {
        transactions = data;
      });
    } catch (error) {
      setState(() {
        transactions = [];
      });
      ShowMessage.error(
        context,
        "Transaction History Loading Failed! Check your interner!",
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp).toLocal();
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: const FinchainAppBar(title: "Transaction History"),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        margin: EdgeInsets.symmetric(
          vertical: heightFactor * 15,
          horizontal: widthFactor * 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: theme.primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(theme.primaryColor),
                ),
              )
            : transactions.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: transactions.map((transactionData) {
                        Transaction transaction =
                            Transaction.fromJson(transactionData);
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: heightFactor * 10,
                            horizontal: widthFactor * 10,
                          ),
                          padding: EdgeInsets.all(widthFactor * 15),
                          decoration: BoxDecoration(
                            color: theme.dialogBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date: ${_formatTimestamp(transaction.timestamp)}",
                                style: TextStyle(
                                  fontSize: widthFactor * 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: heightFactor * 5),
                              Text(
                                "Sender: ${transaction.senderMobile}",
                                style: TextStyle(
                                  fontSize: widthFactor * 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Receiver: ${transaction.receiverMobile}",
                                style: TextStyle(
                                  fontSize: widthFactor * 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              if (transaction.memo != null &&
                                  transaction.memo!.isNotEmpty)
                                Text(
                                  "Memo: ${transaction.memo}",
                                  style: TextStyle(
                                    fontSize: widthFactor * 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              SizedBox(height: heightFactor * 5),
                              Text(
                                "Amount: ${transaction.amount} BDT",
                                style: TextStyle(
                                  fontSize: widthFactor * 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Center(
                    child: Text(
                      "No transactions available!",
                      style: TextStyle(
                        fontSize: widthFactor * 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
      ),
    );
  }
}
