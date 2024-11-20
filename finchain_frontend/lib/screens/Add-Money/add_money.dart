import 'package:finchain_frontend/modules/coming_soon.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Add-Money/add_money_card.dart';
import 'package:finchain_frontend/screens/Add-Money/bank_to_finchain.dart';
import 'package:finchain_frontend/screens/Add-Money/default_fund_modal.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class AddMoney extends StatefulWidget {
  final User user;

  const AddMoney({super.key, required this.user});

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    // final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    // double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Add Money",
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
                      "Select add money option",
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
                      AddMoneyCard(
                        label: "Bank To Finchain",
                        imageUrl: "assets/icons/bank_transfer.svg",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BankToFinchain(user: widget.user),
                            ),
                          );
                        },
                      ),
                      AddMoneyCard(
                        label: "Card To Finchain",
                        imageUrl: "assets/icons/bank_transfer.svg",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ComingSoon(user: widget.user),
                            ),
                          );
                        },
                      ),
                      AddMoneyCard(
                        label: "Default Fund",
                        imageUrl: "assets/icons/bank_transfer.svg",
                        onPressed: () => showDefaultFundModal(
                          context: context,
                          user: widget.user,
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
}
