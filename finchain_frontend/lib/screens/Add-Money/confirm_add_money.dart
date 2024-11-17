import 'package:finchain_frontend/models/Account/account.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/screens/Send-Money/contact_card.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_success_modal.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class ConfirmAddMoney extends StatefulWidget {
  final User user;
  final Account account;
  final String bankName;
  final Contact receiver;
  final double amount;

  const ConfirmAddMoney({
    super.key,
    required this.user,
    required this.account,
    required this.bankName,
    required this.receiver,
    required this.amount,
  });

  @override
  _ConfirmAddMoneyState createState() => _ConfirmAddMoneyState();
}

class _ConfirmAddMoneyState extends State<ConfirmAddMoney> {
  ThemeData theme = AppTheme.getTheme();
  final TextEditingController _refController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refController.text = '';
  }

  void _onConfirmButtonPressed() {
    if (_refController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a reference to confirm!')),
      );
    } else {
      showTransactionSuccessModal(
        context: context,
        user: widget.user,
        contact: widget.receiver,
        amount: widget.amount,
        fee: 100.00,
        reference: _refController.text,
        currentTimestamp: DateTime.now(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double widthFactor = MediaQuery.of(context).size.width / 428;
    final double heightFactor = MediaQuery.of(context).size.height / 926;
    final double fontSize = heightFactor * 13;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Bank To Finchain",
        backButtonExists: true,
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widthFactor * 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heightFactor * 15),
                Container(
                  padding: EdgeInsets.all(heightFactor * 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Receiver",
                        style: TextStyle(
                          color: theme.secondaryHeaderColor,
                          fontSize: heightFactor * 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: heightFactor * 5),
                      ContactCard(contact: widget.receiver),
                    ],
                  ),
                ),
                SizedBox(height: heightFactor * 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(heightFactor * 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Amount",
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "৳ ${widget.amount}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Charge",
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "৳ 0.00",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "৳ ${widget.amount}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: theme.secondaryHeaderColor,
                      ),
                      Padding(
                        padding: EdgeInsets.all(heightFactor * 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bank Details",
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.account.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.account.accNo,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.bankName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: theme.secondaryHeaderColor,
                      ),
                      Padding(
                        padding: EdgeInsets.all(heightFactor * 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reference",
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${_refController.text.length}/50",
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextField(
                                controller: _refController,
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.left,
                                maxLength: 50,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter reference",
                                  counterText: "",
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: heightFactor * 10,
                                    horizontal: widthFactor * 10,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {}); // Update counter display
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightFactor * 50),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: widthFactor * 80,
                        vertical: heightFactor * 15,
                      ),
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widthFactor * 30),
                      ),
                    ),
                    onPressed: _onConfirmButtonPressed,
                    child: const Text(
                      'CONFIRM',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: heightFactor * 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: heightFactor * 40,
        color: theme.primaryColor,
      ),
    );
  }
}
