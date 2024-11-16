import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/screens/Send-Money/contact_card.dart';
import 'package:finchain_frontend/screens/Send-Money/reference_to_send.dart';
import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class AmountToSend extends StatefulWidget {
  final Contact contact;

  const AmountToSend({super.key, required this.contact});

  @override
  State<AmountToSend> createState() => _AmountToSendState();
}

class _AmountToSendState extends State<AmountToSend> {
  double _amount = 0.0;
  final TextEditingController _amountController = TextEditingController();

  void _onAmountChanged(String value) {
    setState(() {
      _amount = double.tryParse(value) ?? 0.0;
    });
  }

  void _navigateToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReferenceToSend(
          contact: widget.contact,
          amount: _amount,
        ),
      ),
    );
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
                      "Balance : 5000 BDT",
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
                      onPressed: _navigateToNextScreen,
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
    _amountController.dispose();
    super.dispose();
  }
}
