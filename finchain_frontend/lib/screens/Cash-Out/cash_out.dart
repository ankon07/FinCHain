import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/screens/Cash-Out/amount_to_send.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class CashOut extends StatefulWidget {
  final User user;
  final String balance;

  const CashOut({super.key, required this.user, required this.balance});

  @override
  State<CashOut> createState() => _CashOutState();
}

class _CashOutState extends State<CashOut> {
  final TextEditingController _agentNumberController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _agentNumberController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {
      _isButtonEnabled = value.length == 11 && RegExp(r'^\d+$').hasMatch(value);
    });
  }

  void _navigateToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmountToSend(
          user: widget.user,
          balance: widget.balance,
          contact: Contact(
            name: 'Cash Out Agent',
            number: _agentNumberController.text,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Cash Out",
        backButtonExists: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0 * widthFactor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Enter Agent Number",
                  style: TextStyle(
                    fontSize: 16 * widthFactor,
                    color: theme.primaryColor,
                  ),
                ),
                Text(
                  "${_agentNumberController.text.length}/11",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16 * widthFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10 * heightFactor),
            TextField(
              controller: _agentNumberController,
              keyboardType: TextInputType.number,
              maxLength: 11,
              decoration: InputDecoration(
                hintText: "Enter 11-digit Agent Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                counterText: "",
              ),
              onChanged: _onTextChanged,
            ),
            SizedBox(height: 20 * heightFactor),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _navigateToNextScreen : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? theme.primaryColor
                      : theme.primaryColor.withOpacity(0.6),
                  padding: EdgeInsets.symmetric(
                    vertical: 12 * heightFactor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16 * widthFactor,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
