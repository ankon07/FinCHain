import 'package:finchain_frontend/models/Account/account.dart';
import 'package:finchain_frontend/models/Account/bank_account.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/screens/Add-Money/choose_receiver.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class SelectBankAcc extends StatefulWidget {
  final User user;
  final BankAccount bankAccount;

  const SelectBankAcc({
    super.key,
    required this.user,
    required this.bankAccount,
  });

  @override
  State<SelectBankAcc> createState() => _SelectBankAccState();
}

class _SelectBankAccState extends State<SelectBankAcc> {
  ThemeData theme = AppTheme.getTheme();
  late List<Account> accounts;

  @override
  void initState() {
    super.initState();
    accounts = List.from(widget.bankAccount.accounts);
  }

  void _addAccount() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final screenHeight = screenSize.height;
        double heightFactor = screenHeight / 926;

        final nameController = TextEditingController();
        final accNoController = TextEditingController();
        final mobNoController = TextEditingController();

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: theme.primaryColor),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: CircleAvatar(
                      radius: heightFactor * 23,
                      backgroundColor: theme.dialogBackgroundColor,
                      child: SvgWidget(
                        imageUrl: "assets/icons/bank_transfer.svg",
                        width: heightFactor * 22,
                        height: heightFactor * 22,
                      ),
                    ),
                  ),
                  SizedBox(width: heightFactor * 10),
                  Text(
                    widget.bankAccount.bankName,
                    style: TextStyle(
                      fontSize: heightFactor * 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: heightFactor * 5),
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: "Account Holder Name"),
              ),
              SizedBox(height: heightFactor * 10),
              TextField(
                controller: accNoController,
                decoration: const InputDecoration(labelText: "Account Number"),
              ),
              SizedBox(height: heightFactor * 10),
              TextField(
                controller: mobNoController,
                decoration: const InputDecoration(labelText: "Mobile Number"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  accounts.add(Account(
                    name: nameController.text,
                    accNo: accNoController.text,
                  ));
                });
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(int index) {
    setState(() {
      accounts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Select account to add money",
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
                  child: accounts.isEmpty
                      ? Center(
                          child: Text(
                            "No accounts found",
                            style: TextStyle(
                              fontSize: heightFactor * 16,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: accounts.length,
                          itemBuilder: (context, index) {
                            var account = accounts[index];
                            return buildSelectBankAccCard(
                              account: account,
                              bankName: widget.bankAccount.bankName,
                              heightFactor: heightFactor,
                              onDelete: () => _deleteAccount(index),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChooseReceiver(
                                      user: widget.user,
                                      account: account,
                                      bankName: widget.bankAccount.bankName,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(heightFactor * 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addAccount,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Account",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: EdgeInsets.all(heightFactor * 12),
                      ),
                    ),
                  ],
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

  Widget buildSelectBankAccCard({
    required Account account,
    required String bankName,
    required double heightFactor,
    required VoidCallback onPressed,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(heightFactor * 5),
        padding: EdgeInsets.symmetric(
          vertical: heightFactor * 5,
          horizontal: heightFactor * 14,
        ),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: theme.primaryColor),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: CircleAvatar(
                    radius: heightFactor * 18,
                    backgroundColor: theme.dialogBackgroundColor,
                    child: SvgWidget(
                      imageUrl: "assets/icons/bank_transfer.svg",
                      width: heightFactor * 17,
                      height: heightFactor * 17,
                    ),
                  ),
                ),
                SizedBox(width: heightFactor * 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: TextStyle(
                        fontSize: heightFactor * 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      account.accNo,
                      style: TextStyle(
                        fontSize: heightFactor * 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      bankName,
                      style: TextStyle(
                        fontSize: heightFactor * 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
