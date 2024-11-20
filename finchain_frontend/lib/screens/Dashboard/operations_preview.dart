import 'package:finchain_frontend/screens/Dashboard/dashboard_navigation.dart';
import 'package:finchain_frontend/screens/Dashboard/operation_card.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/coming_soon.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class OperationsPreview extends StatefulWidget {
  final User user;
  final String balance;

  const OperationsPreview(
      {super.key, required this.user, required this.balance});

  @override
  State<OperationsPreview> createState() => _OperationsPreviewState();
}

class _OperationsPreviewState extends State<OperationsPreview> {
  ThemeData theme = AppTheme.getTheme();
  bool isExpanded = false;
  double _expandedHeightFactor = 0.0;

  void _toggleExpanded() {
    if (isExpanded) {
      setState(() {
        _expandedHeightFactor = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          isExpanded = false;
        });
      });
    } else {
      setState(() {
        isExpanded = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _expandedHeightFactor = 1.0;
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

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: widthFactor * 20,
            right: widthFactor * 20,
            top: widthFactor * 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Operations',
                style: TextStyle(
                  fontSize: 24 * widthFactor,
                  fontWeight: FontWeight.w900,
                  color: theme.primaryColor,
                ),
              ),
              TextButton(
                onPressed: _toggleExpanded,
                child: Text(
                  isExpanded ? 'Show Less' : 'See All',
                  style: TextStyle(
                    fontSize: 11 * widthFactor,
                    fontWeight: FontWeight.w500,
                    color: theme.secondaryHeaderColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: heightFactor * 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthFactor * 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OperationCard(
                    imageUrl: "assets/icons/send_money.svg",
                    label: "Send Money",
                    onTap: () =>
                        DashboardNavigation.instance.navigateToSendMoney(
                      context: context,
                      user: widget.user,
                      balance: widget.balance,
                    ),
                    fontSize: 14 * widthFactor,
                  ),
                  OperationCard(
                    imageUrl: "assets/icons/cross_border.svg",
                    label: "Cross Border",
                    onTap: () =>
                        DashboardNavigation.instance.navigateToCrossBorder(
                      context: context,
                      user: widget.user,
                      balance: widget.balance,
                    ),
                    fontSize: 14 * widthFactor,
                  ),
                  OperationCard(
                    imageUrl: "assets/icons/cash_out.svg",
                    label: "Cash Out",
                    onTap: () => DashboardNavigation.instance.navigateToCashOut(
                      context: context,
                      user: widget.user,
                      balance: widget.balance,
                    ),
                    fontSize: 14 * widthFactor,
                  ),
                ],
              ),
              SizedBox(height: heightFactor * 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OperationCard(
                    imageUrl: "assets/icons/add_money.svg",
                    label: "Add Money",
                    onTap: () =>
                        DashboardNavigation.instance.navigateToAddMoney(
                      context: context,
                      user: widget.user,
                    ),
                    fontSize: 14 * widthFactor,
                  ),
                  OperationCard(
                    imageUrl: "assets/icons/payment.svg",
                    label: "Payment",
                    onTap: () => DashboardNavigation.instance.navigateToPayment(
                      context: context,
                      user: widget.user,
                      balance: widget.balance,
                    ),
                    fontSize: 14 * widthFactor,
                  ),
                  OperationCard(
                    imageUrl: "assets/icons/mobile_recharge.svg",
                    label: "Mobile Recharge",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComingSoon(
                          user: widget.user,
                          title: "Mobile Recharge",
                        ),
                      ),
                    ),
                    fontSize: 14 * widthFactor,
                  ),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isExpanded ? heightFactor * 105 : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _expandedHeightFactor,
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Column(
                          children: [
                            SizedBox(height: heightFactor * 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OperationCard(
                                  imageUrl: "assets/icons/bank_transfer.svg",
                                  label: "Bank Transfer",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ComingSoon(
                                        user: widget.user,
                                        title: "Bank Transfer",
                                      ),
                                    ),
                                  ),
                                  fontSize: 14 * widthFactor,
                                ),
                                OperationCard(
                                  imageUrl: "assets/icons/bills.svg",
                                  label: "Bill",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ComingSoon(
                                        user: widget.user,
                                        title: "Bill",
                                      ),
                                    ),
                                  ),
                                  fontSize: 14 * widthFactor,
                                ),
                                OperationCard(
                                  imageUrl: "assets/icons/donation.svg",
                                  label: "Donation",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ComingSoon(
                                        user: widget.user,
                                        title: "Donation",
                                      ),
                                    ),
                                  ),
                                  fontSize: 14 * widthFactor,
                                ),
                              ],
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
