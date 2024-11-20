import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/screens/Send-Money/contact_card.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_failed_modal.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_success_modal.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';

class AmountToSend extends StatefulWidget {
  final User user;
  final Contact contact;
  final String balance;

  const AmountToSend({
    super.key,
    required this.contact,
    required this.balance,
    required this.user,
  });

  @override
  State<AmountToSend> createState() => _AmountToSendState();
}

class _AmountToSendState extends State<AmountToSend> {
  double _amount = 0.0;
  final TextEditingController _amountController = TextEditingController();
  ApiService apiService = ApiService();
  bool isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _onAmountChanged(String value) {
    setState(() {
      _amount = double.tryParse(value) ?? 0.0;
    });
  }

  void _showTransactionStatusModal(BuildContext context) async {
    _setLoading(true);
    try {
      await apiService.sendPayment(
        widget.contact.number,
        _amountController.text,
        "Cash Out",
      );

      _setLoading(false);
      showTransactionSuccessModal(
        context: context,
        user: widget.user,
        contact: widget.contact,
        amount: double.parse(_amountController.text),
        fee: 14.00,
        reference: "Cash Out",
        currentTimestamp: DateTime.now(),
      );
    } catch (e) {
      _setLoading(false);
      showTransactionFailedModal(
        context,
        widget.user,
        "Failed to Cash Out!",
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
        title: "Cash Out",
        backButtonExists: true,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        message: "Processing cash out...",
        child: Expanded(
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
                  padding: EdgeInsets.all(widthFactor * 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: widthFactor * 20),
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                fontSize: widthFactor * 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: widthFactor * 10),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final parentWidth = constraints.maxWidth;
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: widthFactor * 20),
                            width: parentWidth * 0.6,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "BDT",
                                      style: TextStyle(
                                        fontSize: widthFactor * 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: SizedBox(
                                    width: screenWidth * 0.4,
                                    height: screenHeight * 0.2,
                                    child: TextField(
                                      controller: _amountController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      onChanged: _onAmountChanged,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: "0.00",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Text(
                        "Balance : ${widget.balance} BDT",
                        style: TextStyle(
                          fontSize: widthFactor * 16,
                          color: const Color(0xFFD2B48C),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: theme.primaryColor,
                  thickness: 5,
                ),
                SizedBox(height: heightFactor * 30),
                if (_amount > 0)
                  AnimatedOpacity(
                    opacity: _amount > 0 ? 1.0 : 0.0,
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
    _amountController.dispose();
    super.dispose();
  }
}
