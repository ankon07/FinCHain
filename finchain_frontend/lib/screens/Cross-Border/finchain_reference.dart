import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_failed_modal.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_success_modal.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class FinchainReference extends StatefulWidget {
  final User user;
  final String balance;
  final String receiverNumber;
  final double amount;
  final String selectedCountry;
  final String selectedCurrency;
  final double conversionRate;

  const FinchainReference({
    super.key,
    required this.user,
    required this.balance,
    required this.receiverNumber,
    required this.amount,
    required this.selectedCountry,
    required this.selectedCurrency,
    required this.conversionRate,
  });

  @override
  State<FinchainReference> createState() => _FinchainReferenceState();
}

class _FinchainReferenceState extends State<FinchainReference> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  bool _isLoading = false;
  final ApiService apiService = ApiService();

  void _setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    }
  }

  Future<void> _handleNext() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await apiService.sendPayment(
        widget.receiverNumber,
        widget.amount.toString(),
        _referenceController.text,
      );

      if (!mounted) return;

      showTransactionSuccessModal(
        context: context,
        user: widget.user,
        contact: Contact(
            number: widget.receiverNumber,
            name: ''), // Creating a Contact object with receiver number
        amount: widget.amount,
        fee: 5.00,
        reference: _referenceController.text,
        currentTimestamp: DateTime.now(),
      );
    } catch (e) {
      if (!mounted) return;
      showTransactionFailedModal(
        context,
        widget.user,
        "Failed to transact!",
      );
    }
  }

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
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
        title: "Cross Border",
        backButtonExists: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: "Processing payment...",
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(widthFactor * 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.primaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(widthFactor * 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transfer Details",
                        style: TextStyle(
                          fontSize: widthFactor * 18,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(height: heightFactor * 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Receiver's Number:",
                            style: TextStyle(
                              fontSize: widthFactor * 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "+${widget.receiverNumber}",
                            style: TextStyle(
                              fontSize: widthFactor * 16,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightFactor * 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amount (BDT):",
                            style: TextStyle(
                              fontSize: widthFactor * 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "৳ ${widget.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: widthFactor * 16,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightFactor * 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Converted Amount:",
                            style: TextStyle(
                              fontSize: widthFactor * 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${(widget.amount / widget.conversionRate).toStringAsFixed(2)} ${widget.selectedCurrency}",
                            style: TextStyle(
                              fontSize: widthFactor * 16,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                            "(max 25 characters)",
                            style: TextStyle(
                              fontSize: widthFactor * 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: heightFactor * 10),
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
                        child: TextFormField(
                          controller: _referenceController,
                          keyboardType: TextInputType.text,
                          maxLength: 25,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a reference';
                            }
                            return null;
                          },
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: widthFactor * 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Type here...",
                            border: InputBorder.none,
                            counterText: "",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widthFactor * 20,
                    vertical: widthFactor * 20,
                  ),
                  child: ElevatedButton(
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: widthFactor * 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: widthFactor * 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
