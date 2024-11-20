import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/screens/Send-Money/contact_card.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_failed_modal.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_success_modal.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
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
  bool isLoading = false;
  final TextEditingController _referenceController = TextEditingController();
  ApiService apiService = ApiService();

  void _setLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  void _onReferenceChanged(String value) {
    setState(() {
      _reference = value;
    });
  }

  void _showTransactionStatusModal(BuildContext context) async {
    if (_reference.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reference must not exceed 50 words'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _setLoading(true);
    try {
      await apiService.sendPayment(
        widget.contact.number,
        widget.amount.toString(),
        _referenceController.text,
      );

      if (mounted) {
        showTransactionSuccessModal(
          context: context,
          user: widget.user,
          contact: widget.contact,
          amount: widget.amount,
          fee: 5.00,
          reference: _referenceController.text,
          currentTimestamp: DateTime.now(),
        );
      }
    } catch (e) {
      if (mounted) {
        showTransactionFailedModal(
          context,
          widget.user,
          "Failed to process transaction. Please try again.",
        );
      }
      debugPrint('Transaction error: $e');
    } finally {
      _setLoading(false);
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
      body: LoadingOverlay(
        isLoading: isLoading,
        message: "Processing transaction...",
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
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
                          color: theme.primaryColor,
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
              Container(
                margin: EdgeInsets.symmetric(vertical: heightFactor * 20),
                padding: EdgeInsets.all(widthFactor * 20),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAmountColumn(
                        "Amount", "${widget.amount} BDT", theme, widthFactor),
                    _buildAmountColumn(
                        "Charge", "0.00 BDT", theme, widthFactor),
                    _buildAmountColumn(
                        "Total", "${widget.amount} BDT", theme, widthFactor),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: widthFactor * 20),
                padding: EdgeInsets.all(widthFactor * 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widthFactor * 10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reference",
                          style: TextStyle(
                            fontSize: widthFactor * 17,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor,
                          ),
                        ),
                        Text(
                          "${_reference.split(' ').length}/50 words",
                          style: TextStyle(
                            fontSize: widthFactor * 12,
                            fontWeight: FontWeight.w400,
                            color: _reference.split(' ').length > 50
                                ? Colors.red
                                : Colors.grey,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: heightFactor * 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(widthFactor * 8),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: widthFactor * 15,
                        vertical: widthFactor * 5,
                      ),
                      child: TextField(
                        controller: _referenceController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        minLines: 3,
                        onChanged: _onReferenceChanged,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: widthFactor * 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Add a reference for this transaction...",
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.7),
                            fontSize: widthFactor * 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightFactor * 30),
              if (_reference.isNotEmpty)
                AnimatedOpacity(
                  opacity: _reference.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widthFactor * 20,
                      vertical: widthFactor * 10,
                    ),
                    child: ElevatedButton(
                      onPressed: () => _showTransactionStatusModal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding:
                            EdgeInsets.symmetric(vertical: widthFactor * 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(widthFactor * 10),
                        ),
                        elevation: 2,
                      ),
                      child: Center(
                        child: Text(
                          "Confirm Payment",
                          style: TextStyle(
                            fontSize: widthFactor * 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: heightFactor * 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountColumn(
      String title, String amount, ThemeData theme, double widthFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: widthFactor * 14,
            fontWeight: FontWeight.w500,
            color: theme.primaryColor,
          ),
        ),
        SizedBox(height: widthFactor * 5),
        Text(
          amount,
          style: TextStyle(
            fontSize: widthFactor * 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }
}
