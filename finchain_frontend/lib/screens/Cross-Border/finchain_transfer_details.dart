import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
import 'package:finchain_frontend/screens/Cross-Border/finchain_reference.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinchainTransferDetails extends StatefulWidget {
  final User user;
  final String balance;
  final String selectedCountry;
  final String selectedCurrency;
  final double conversionRate;

  const FinchainTransferDetails({
    super.key,
    required this.user,
    required this.balance,
    required this.selectedCountry,
    required this.selectedCurrency,
    required this.conversionRate,
  });

  @override
  State<FinchainTransferDetails> createState() =>
      _FinchainTransferDetailsState();
}

class _FinchainTransferDetailsState extends State<FinchainTransferDetails> {
  final _formKey = GlobalKey<FormState>();
  final _receiverController = TextEditingController();
  final _amountController = TextEditingController();
  bool showNextButton = false;
  bool _isLoading = false;
  double? convertedAmount;

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

    _setLoading(true);
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FinchainReference(
            user: widget.user,
            balance: widget.balance,
            receiverNumber: _receiverController.text,
            amount: double.parse(_amountController.text),
            selectedCountry: widget.selectedCountry,
            selectedCurrency: widget.selectedCurrency,
            conversionRate: widget.conversionRate,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _receiverController.addListener(_validateInputs);
    _amountController.addListener(_validateInputs);
    _amountController.text = '0.00';
  }

  @override
  void dispose() {
    _receiverController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      showNextButton = _receiverController.text.length >= 10 &&
          _amountController.text.isNotEmpty;

      if (_amountController.text.isNotEmpty) {
        double amount = double.tryParse(_amountController.text) ?? 0;
        convertedAmount = amount / widget.conversionRate;
      } else {
        convertedAmount = null;
      }
    });
  }

  Widget _amountButton(double amount) {
    return ElevatedButton(
      onPressed: () {
        _amountController.text = amount.toStringAsFixed(2);
        _validateInputs();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        minimumSize: Size(80, 35),
      ),
      child: Text(
        amount.toStringAsFixed(0),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    double heightFactor = screenHeight / 926;
    double widthFactor = screenWidth / 428;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Cross Border",
        backButtonExists: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: "Processing transfer details...",
        child: Form(
          key: _formKey,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(heightFactor * 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Transfer Details",
                    style: TextStyle(
                      fontSize: heightFactor * 18,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                  SizedBox(height: heightFactor * 20),
                  Container(
                    padding: EdgeInsets.all(heightFactor * 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.primaryColor, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _receiverController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Receiver's Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        SizedBox(height: heightFactor * 20),
                        Text(
                          "Amount",
                          style: TextStyle(
                            color: theme.secondaryHeaderColor,
                            fontWeight: FontWeight.w600,
                            fontSize: heightFactor * 15,
                          ),
                        ),
                        SizedBox(height: heightFactor * 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 8),
                                _amountButton(1000),
                                const SizedBox(height: 8),
                                _amountButton(5000),
                                const SizedBox(height: 8),
                                _amountButton(10000),
                                const SizedBox(height: 8),
                                _amountButton(50000),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                SizedBox(
                                  width: widthFactor * 200,
                                  child: TextField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: widthFactor * 36,
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onTap: () {
                                      if (_amountController.text == '0.00') {
                                        _amountController.clear();
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        _amountController.text = '0.00';
                                        _amountController.selection =
                                            TextSelection.fromPosition(
                                          TextPosition(
                                            offset:
                                                _amountController.text.length,
                                          ),
                                        );
                                      }
                                      _validateInputs();
                                    },
                                  ),
                                ),
                                Text(
                                  "BDT",
                                  style: TextStyle(
                                    fontSize: heightFactor * 16,
                                    fontWeight: FontWeight.w500,
                                    color: theme.secondaryHeaderColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: heightFactor * 20),
                        if (convertedAmount != null) ...[
                          Container(
                            padding: EdgeInsets.all(heightFactor * 10),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Converted Amount:",
                                      style: TextStyle(
                                        fontSize: heightFactor * 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${convertedAmount!.toStringAsFixed(2)} ${widget.selectedCurrency}",
                                      style: TextStyle(
                                        fontSize: heightFactor * 16,
                                        fontWeight: FontWeight.w600,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: heightFactor * 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Current Balance:",
                                      style: TextStyle(
                                        fontSize: heightFactor * 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "৳ ${widget.balance}",
                                      style: TextStyle(
                                        fontSize: heightFactor * 16,
                                        fontWeight: FontWeight.w600,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: heightFactor * 50),
                  if (showNextButton)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          padding:
                              EdgeInsets.symmetric(vertical: heightFactor * 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: heightFactor * 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
