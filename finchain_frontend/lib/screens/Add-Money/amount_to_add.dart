import 'package:finchain_frontend/models/Account/account.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
import 'package:finchain_frontend/screens/Add-Money/confirm_add_money.dart';
import 'package:finchain_frontend/screens/Send-Money/contact_card.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class AmountToAdd extends StatefulWidget {
  final User user;
  final Account account;
  final String bankName;
  final Contact receiver;

  const AmountToAdd({
    super.key,
    required this.user,
    required this.account,
    required this.bankName,
    required this.receiver,
  });

  @override
  _AmountToAddState createState() => _AmountToAddState();
}

class _AmountToAddState extends State<AmountToAdd> {
  ThemeData theme = AppTheme.getTheme();
  final TextEditingController _amountController = TextEditingController();
  final double _minimumAmount = 50;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = '0.00';
    _amountController.addListener(() {
      if (_amountController.text == '0.00') {
        _amountController.clear();
      }
    });
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _selectAmount(double amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  Future<void> _onNextButtonPressed() async {
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount < _minimumAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Provide a value over or equal to minimum value.'),
        ),
      );
      return;
    }

    _setLoading(true);
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmAddMoney(
            user: widget.user,
            account: widget.account,
            bankName: widget.bankName,
            receiver: widget.receiver,
            amount: amount,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        _setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double widthFactor = MediaQuery.of(context).size.width / 428;
    final double heightFactor = MediaQuery.of(context).size.height / 926;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Bank To Finchain",
        backButtonExists: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: "Processing amount...",
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
                  padding: EdgeInsets.only(
                    left: heightFactor * 10,
                    right: heightFactor * 10,
                    top: heightFactor * 10,
                    bottom: heightFactor * 40,
                  ),
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
                                          offset: _amountController.text.length,
                                        ),
                                      );
                                    }
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
                      SizedBox(height: heightFactor * 30),
                      Text(
                        "Minimum amount: ৳${_minimumAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: theme.secondaryHeaderColor,
                          fontSize: heightFactor * 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightFactor * 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onNextButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: heightFactor * 15),
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
    );
  }

  Widget _amountButton(double amount) {
    return ElevatedButton(
      onPressed: () => _selectAmount(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        minimumSize: const Size(80, 35),
      ),
      child: Text(
        amount.toStringAsFixed(0),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
