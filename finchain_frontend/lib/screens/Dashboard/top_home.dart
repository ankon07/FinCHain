import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Transaction-History/transaction_history.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';

class TopHome extends StatefulWidget {
  final User user;

  const TopHome({super.key, required this.user});

  @override
  State<TopHome> createState() => _TopHomeState();
}

class _TopHomeState extends State<TopHome> {
  ThemeData theme = AppTheme.getTheme();
  ApiService apiService = ApiService();
  String _balance = "0.00";
  bool isBalanceShowing = false;
  double _balanceOpacity = 0.0;
  bool isHistoryShowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isBalanceShowing = false;
    getBalance();
    fetchImageUrl();
  }

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> fetchImageUrl() async {}

  Future<void> _logout() async {}

  Future<void> getBalance() async {
    _setLoading(true);
    try {
      String balance = await apiService.fetchBalance();
      setState(() {
        _balance = balance;
      });
    } catch (e) {
      debugPrint('Error fetching balance: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _toggleBalanceVisibility() {
    if (isBalanceShowing) {
      setState(() {
        _balanceOpacity = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          isBalanceShowing = false;
        });
      });
    } else {
      setState(() {
        isBalanceShowing = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _balanceOpacity = 1.0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          ),
          padding: EdgeInsets.only(
            bottom: widthFactor * 30,
            left: widthFactor * 20,
            right: widthFactor * 20,
            top: widthFactor * 70,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: widthFactor * 183.14,
                    height: heightFactor * 57,
                    padding: EdgeInsets.all(widthFactor * 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(widthFactor * 25)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: widthFactor * 86.57,
                          decoration: BoxDecoration(
                            color: isBalanceShowing
                                ? theme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.all(
                                Radius.circular(heightFactor * 25)),
                          ),
                          child: IconButton(
                            onPressed: _toggleBalanceVisibility,
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.wallet,
                                key: ValueKey<bool>(isBalanceShowing),
                                size: widthFactor * 33,
                                color: isBalanceShowing
                                    ? Colors.white
                                    : theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TransactionHistory(user: widget.user),
                              ),
                            );
                          },
                          child: Container(
                            width: widthFactor * 86.57,
                            padding: EdgeInsets.symmetric(
                              vertical: heightFactor * 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(heightFactor * 25),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.history,
                                size: widthFactor * 33,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: widthFactor * 50,
                    height: widthFactor * 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4.0,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightFactor * 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.user.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widthFactor * 20,
                    ),
                  )
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isBalanceShowing ? heightFactor * 105 : 0,
                curve: Curves.easeInOut,
                padding: EdgeInsets.only(
                    left: widthFactor * 20, bottom: widthFactor * 20),
                width: screenWidth * 0.9,
                child: LoadingOverlay(
                  isLoading: isLoading,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _balanceOpacity,
                    curve: Curves.easeInOut,
                    child: isBalanceShowing
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Balance",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widthFactor * 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "\$ $_balance",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widthFactor * 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: isBalanceShowing ? -20 * heightFactor : -70 * heightFactor,
          left: (screenWidth - widthFactor * 366) / 2,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isBalanceShowing ? heightFactor * 50 : 0,
            child: AnimatedOpacity(
              opacity: isBalanceShowing ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Visibility(
                visible: isBalanceShowing,
                child: Container(
                  width: widthFactor * 366,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    borderRadius:
                        BorderRadius.all(Radius.circular(widthFactor * 25)),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: heightFactor * 10,
                    horizontal: widthFactor * 15,
                  ),
                  child: GestureDetector(
                    onTap: _toggleBalanceVisibility,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: heightFactor * 32,
                          height: heightFactor * 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.primaryColorLight,
                          ),
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: theme.primaryColor,
                            size: heightFactor * 20,
                          ),
                        ),
                        SizedBox(width: widthFactor * 10),
                        Flexible(
                          child: Text(
                            "Hide this section",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: widthFactor * 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
