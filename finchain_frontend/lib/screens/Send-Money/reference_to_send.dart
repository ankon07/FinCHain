import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/screens/Send-Money/contact_card.dart';
// import 'package:finchain_frontend/screens/Send-Money/pin_to_send.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_failed_modal.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_success_modal.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class ReferenceToSend extends StatefulWidget {
  final User user;
  final Contact contact;
  final double amount;

  const ReferenceToSend({
    super.key,
    required this.contact,
    required this.amount,
    required this.user,
  });

  @override
  State<ReferenceToSend> createState() => _ReferenceToSendState();
}

class _ReferenceToSendState extends State<ReferenceToSend> {
  String _reference = "";
  final TextEditingController _referenceController = TextEditingController();
  ApiService apiService = ApiService();

  void _onReferenceChanged(String value) {
    setState(() {
      _reference = value;
    });
  }

  void _showTransactionStatusModal(BuildContext context) async {
    try {
      final fee = await apiService.sendPayment(
        widget.contact.number,
        widget.amount.toString(),
        _referenceController.text,
      );

      showTransactionSuccessModal(
        context: context,
        user: widget.user,
        contact: widget.contact,
        amount: widget.amount,
        fee: double.parse(fee),
        reference: _referenceController.text,
        currentTimestamp: DateTime.now(),
      );
    } catch (e) {
      showTransactionFailedModal(
        context,
        widget.user,
        "Failed to transact!",
      );
    }
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
        title: "Send Money",
        backButtonExists: true,
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(widthFactor * 20),
                      child: Text(
                        "Receiver",
                        style: TextStyle(
                          fontSize: widthFactor * 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFD2B48C),
                      thickness: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.all(widthFactor * 20),
                      child: ContactCard(contact: widget.contact),
                    )
                  ],
                ),
              ),
              Divider(
                color: theme.primaryColor,
                thickness: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: widthFactor * 10,
                  horizontal: widthFactor * 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount",
                          style: TextStyle(
                            fontSize: widthFactor * 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${widget.amount} BDT",
                          style: TextStyle(
                            fontSize: widthFactor * 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Charge",
                          style: TextStyle(
                            fontSize: widthFactor * 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "0.00 BDT",
                          style: TextStyle(
                            fontSize: widthFactor * 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: widthFactor * 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${widget.amount} BDT",
                          style: TextStyle(
                            fontSize: widthFactor * 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: theme.primaryColor,
                thickness: 5,
              ),
              Padding(
                padding: EdgeInsets.all(widthFactor * 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reference:",
                          style: TextStyle(
                            fontSize: widthFactor * 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "(max 50 words)",
                          style: TextStyle(
                            fontSize: widthFactor * 8,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: heightFactor * 5),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.dialogBackgroundColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(widthFactor * 8),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: widthFactor * 10),
                      child: TextField(
                        controller: _referenceController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: _onReferenceChanged,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: widthFactor * 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Type here...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: theme.primaryColor,
                thickness: 2,
              ),
              SizedBox(height: heightFactor * 30),
              if (_reference.isNotEmpty)
                AnimatedOpacity(
                  opacity: _reference.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widthFactor * 20,
                        vertical: widthFactor * 20),
                    child: ElevatedButton(
                      onPressed: () => _showTransactionStatusModal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding:
                            EdgeInsets.symmetric(vertical: widthFactor * 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
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

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }
}
