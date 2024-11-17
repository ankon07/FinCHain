import 'dart:ui';

import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/screens/bottom_navbar.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

void showDefaultFundModal({
  required BuildContext context,
  required User user,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: DefaultFundModal(user: user),
        ),
      );
    },
  );
}

class DefaultFundModal extends StatefulWidget {
  final User user;

  const DefaultFundModal({
    super.key,
    required this.user,
  });

  @override
  State<DefaultFundModal> createState() => _DefaultFundModalState();
}

class _DefaultFundModalState extends State<DefaultFundModal> {
  ApiService apiService = ApiService();

  bool _isLoading = false;
  bool? _isSuccess;

  Future<void> _getDefaultFund() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await apiService.fundAccount(widget.user.contact);
      setState(() {
        _isSuccess = true;
      });
    } catch (e) {
      setState(() {
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(heightFactor * 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: heightFactor * 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/finchain.png',
                          height: heightFactor * 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: widthFactor * 8),
                        Text(
                          "FINCHAIN",
                          style: TextStyle(
                            fontSize: heightFactor * 24,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heightFactor * 4),
                  Text(
                    _isSuccess == null
                        ? "Confirm Fund"
                        : _isSuccess!
                            ? "Transaction Successful"
                            : "Transaction Failed",
                    style: TextStyle(
                      fontSize: heightFactor * 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(height: widthFactor * 20, color: Colors.black45),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(color: theme.primaryColor),
                )
              else if (_isSuccess == null)
                ElevatedButton(
                  onPressed: _getDefaultFund,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      const Text("Confirm Fund"),
                    ],
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgWidget(
                      imageUrl: _isSuccess!
                          ? "assets/icons/success.svg"
                          : "assets/icons/fail.svg",
                      width: heightFactor * 83,
                      height: heightFactor * 83,
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: heightFactor * 25),
        ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(user: widget.user),
              ),
              (Route<dynamic> route) => false,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.home,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 5),
              const Text("Go to Home"),
            ],
          ),
        ),
      ],
    );
  }
}
