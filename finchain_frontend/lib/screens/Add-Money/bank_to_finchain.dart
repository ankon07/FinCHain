import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/Account/account.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Add-Money/add_money_card.dart';
import 'package:finchain_frontend/screens/Add-Money/select_bank_acc.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:finchain_frontend/models/Account/bank_account.dart';

class BankToFinchain extends StatefulWidget {
  final User user;

  const BankToFinchain({super.key, required this.user});

  @override
  State<BankToFinchain> createState() => _BankToFinchainState();
}

class _BankToFinchainState extends State<BankToFinchain> {
  List<BankAccount> bankList = [
    BankAccount(
      bankName: "AB Bank Limited",
      accounts: [
        Account(
          name: "John Doe",
          accNo: "1234567890",
        ),
      ],
    ),
    BankAccount(
      bankName: "Agrani Bank",
      accounts: [
        Account(
          name: "Jane Smith",
          accNo: "2345678901",
        ),
      ],
    ),
    BankAccount(
      bankName: "City Bank Limited",
      accounts: [
        Account(
          name: "Alice Johnson",
          accNo: "3456789012",
        ),
      ],
    ),
    BankAccount(
      bankName: "Dutch Bangla Bank Limited",
      accounts: [
        Account(
          name: "Bob Brown",
          accNo: "4567890123",
        ),
      ],
    ),
    BankAccount(
      bankName: "Grameen Bank",
      accounts: [
        Account(
          name: "Charlie White",
          accNo: "5678901234",
        ),
      ],
    ),
    BankAccount(
      bankName: "Islami Bank Limited",
      accounts: [
        Account(
          name: "David Green",
          accNo: "6789012345",
        ),
      ],
    ),
    BankAccount(
      bankName: "Mutual Trust Bank Limited",
      accounts: [
        Account(
          name: "Eve Black",
          accNo: "7890123456",
        ),
      ],
    ),
    BankAccount(
      bankName: "Pubali Bank PLC",
      accounts: [
        Account(
          name: "Frank Yellow",
          accNo: "8901234567",
        ),
      ],
    ),
    BankAccount(
      bankName: "Sonali Bank PLC",
      accounts: [
        Account(
          name: "Grace Blue",
          accNo: "9012345678",
        ),
      ],
    ),
  ];

  List<BankAccount> _filteredBankList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredBankList = bankList;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredBankList = bankList
          .where((bank) => bank.bankName
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Bank To Finchain",
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
                  children: [
                    Icon(
                      Icons.search,
                      color: theme.primaryColor,
                    ),
                    SizedBox(width: heightFactor * 5),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search Bank Name",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: heightFactor * 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightFactor * 20),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(heightFactor * 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: _filteredBankList.isEmpty
                      ? Center(
                          child: Text(
                            "No banks found",
                            style: TextStyle(
                              fontSize: heightFactor * 16,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredBankList.length,
                          itemBuilder: (context, index) {
                            var bank = _filteredBankList[index];
                            return AddMoneyCard(
                              label: bank.bankName,
                              imageUrl: "assets/icons/bank_transfer.svg",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectBankAcc(
                                      user: widget.user,
                                      bankAccount: bank,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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
}
