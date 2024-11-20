import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/show_message.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
import 'package:finchain_frontend/screens/Transaction-History/transaction_details_modal.dart';
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
      final data = await apiService.fetchTransactions();
      setState(() {
        transactions = data;
      });
    } catch (error) {
      setState(() {
        transactions = [];
      });
      ShowMessage.error(
        context,
        "Transaction History Loading Failed! Check your internet!",
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

  String _getTransactionTitle(Transaction transaction) {
    if (transaction.memo == "Cash Out") {
      return "Cash Out";
    } else if (transaction.memo == "Payment") {
      return "Payment";
    } else {
      return transaction.receiverMobile == widget.user.contact
          ? "Received Money"
          : "Send Money";
    }
  }

  Color _getAmountColor(Transaction transaction) {
    if (transaction.receiverMobile == widget.user.contact) {
      return Colors.green;
    }
    return Colors.orange;
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
      backgroundColor: Colors.white,
      appBar: const FinchainAppBar(
        title: "Transaction History",
        backButtonExists: true,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        message: "Loading transactions...",
        child: RefreshIndicator(
          onRefresh: getTransactions,
          child: transactions.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: heightFactor * 15,
                    horizontal: widthFactor * 20,
                  ),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    Transaction transaction =
                        Transaction.fromJson(transactions[index]);
                    String title = _getTransactionTitle(transaction);
                    bool isIncoming =
                        transaction.receiverMobile == widget.user.contact;
                    String formattedTimestamp =
                        _formatTimestamp(transaction.timestamp);

                    return GestureDetector(
                      onTap: () => showTransactionDetailsModal(
                        context: context,
                        transaction: transaction,
                        title: title,
                        formattedTimestamp: formattedTimestamp,
                        userMobile: widget.user.contact,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: heightFactor * 15),
                        padding: EdgeInsets.all(widthFactor * 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(widthFactor * 12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Transaction Icon
                            Container(
                              width: widthFactor * 40,
                              height: widthFactor * 40,
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(widthFactor * 10),
                              ),
                              child: Icon(
                                isIncoming
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: _getAmountColor(transaction),
                                size: widthFactor * 24,
                              ),
                            ),
                            SizedBox(width: widthFactor * 15),
                            // Transaction Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: widthFactor * 16,
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: heightFactor * 4),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(
                                        DateTime.parse(transaction.timestamp)),
                                    style: TextStyle(
                                      fontSize: widthFactor * 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Amount
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${isIncoming ? '+' : '-'}${transaction.amount} BDT",
                                  style: TextStyle(
                                    fontSize: widthFactor * 16,
                                    fontWeight: FontWeight.w600,
                                    color: _getAmountColor(transaction),
                                  ),
                                ),
                                if (transaction.fee.isNotEmpty)
                                  Text(
                                    "Fee: ${transaction.fee} BDT",
                                    style: TextStyle(
                                      fontSize: widthFactor * 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: widthFactor * 50,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: heightFactor * 20),
                      Text(
                        "No transactions yet",
                        style: TextStyle(
                          fontSize: widthFactor * 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
