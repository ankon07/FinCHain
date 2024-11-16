import 'package:finchain_frontend/models/Account/account.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_failed_modal.dart';
import 'package:finchain_frontend/screens/Send-Money/transaction_success_modal.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class OtpConfirmationAM extends StatefulWidget {
  final User user;
  final Account account;
  final String bankName;
  final Contact receiver;
  final double amount;
  final String reference;
  final DateTime currentTimestamp;

  const OtpConfirmationAM({
    super.key,
    required this.user,
    required this.account,
    required this.bankName,
    required this.receiver,
    required this.amount,
    required this.reference,
    required this.currentTimestamp,
  });

  @override
  _OtpConfirmationAMState createState() => _OtpConfirmationAMState();
}

class _OtpConfirmationAMState extends State<OtpConfirmationAM> {
  ThemeData theme = AppTheme.getTheme();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpController.text = '';
  }

  void _onConfirmButtonPressed() {
    if (_otpController.text == "1111") {
      showTransactionSuccessModal(
        context,
        widget.receiver,
        widget.amount,
        widget.reference,
        widget.currentTimestamp,
      );
    } else {
      showTransactionFailedModal(context, "Verification Failed!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double widthFactor = MediaQuery.of(context).size.width / 428;
    final double heightFactor = MediaQuery.of(context).size.height / 926;
    final double fontSize = heightFactor * 16;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Bank To Finchain",
        backButtonExists: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(
          left: widthFactor * 16,
          right: widthFactor * 16,
          top: heightFactor * 30,
          bottom: heightFactor * 50,
        ),
        padding: EdgeInsets.symmetric(
          vertical: heightFactor * 40,
          horizontal: heightFactor * 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: theme.primaryColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgWidget(
                      imageUrl: "assets/icons/bank_transfer.svg",
                      width: heightFactor * 28,
                      height: heightFactor * 28,
                    ),
                    SizedBox(width: heightFactor * 5),
                    Text(
                      widget.bankName,
                      style: TextStyle(
                        fontSize: heightFactor * 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/finchain.png',
                      height: heightFactor * 40,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: widthFactor * 5),
                    Text(
                      "FINCHAIN",
                      style: TextStyle(
                        fontSize: heightFactor * 12,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: heightFactor * 20),
            Text(
              "Welcome ${widget.user.name}",
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: heightFactor * 40),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.user.name,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: theme.secondaryHeaderColor,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mobile",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.receiver.number,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: theme.secondaryHeaderColor,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account Number",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.account.accNo,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: theme.secondaryHeaderColor,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "OTP",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    TextField(
                      controller: _otpController,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter OTP",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: heightFactor * 10.0,
                          horizontal: heightFactor * 10.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                    ),
                  ],
                ),
              ],
            ),
          ],
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
