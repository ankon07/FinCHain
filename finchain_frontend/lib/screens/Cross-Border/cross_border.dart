import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Cross-Border/cross_border_card.dart';
import 'package:finchain_frontend/screens/Cross-Border/finchain_to_finchain.dart';
import 'package:finchain_frontend/modules/coming_soon.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class CrossBorder extends StatefulWidget {
  final User user;
  final String balance;

  const CrossBorder({
    super.key,
    required this.user,
    required this.balance,
  });

  @override
  State<CrossBorder> createState() => _CrossBorderState();
}

class _CrossBorderState extends State<CrossBorder> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Cross Border",
        backButtonExists: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(heightFactor * 20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: heightFactor * 5,
                  horizontal: heightFactor * 14,
                ),
                decoration: BoxDecoration(
                  color: theme.canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Select transfer option",
                      style: TextStyle(
                        fontSize: heightFactor * 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightFactor * 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.all(heightFactor * 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      CrossBorderCard(
                        label: "Finchain to Finchain",
                        imageUrl: "assets/icons/send_money.svg",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FinchainToFinchain(
                                user: widget.user,
                                balance: widget.balance,
                              ),
                            ),
                          );
                        },
                      ),
                      CrossBorderCard(
                        label: "Finchain to Bank",
                        imageUrl: "assets/icons/bank_transfer.svg",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComingSoon(
                                user: widget.user,
                                title: "Cross Border",
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
