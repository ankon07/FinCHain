import 'package:finchain_frontend/screens/Dashboard/agents.dart';
import 'package:finchain_frontend/screens/Dashboard/offers_section.dart';
import 'package:finchain_frontend/screens/Dashboard/operations_preview.dart';
import 'package:finchain_frontend/screens/Dashboard/top_home.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final User user;

  const Dashboard({super.key, required this.user});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ThemeData theme = AppTheme.getTheme();
  ApiService apiService = ApiService();

  String _balance = "0.00";

  @override
  void initState() {
    super.initState();
    getBalance();
  }

  Future<void> getBalance() async {
    String balance = await apiService.fetchBalance();
    setState(() {
      _balance = balance;
    });
  }

  Future<void> fetchImageUrl() async {}

  Future<void> _logout() async {}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return SingleChildScrollView(
      child: Column(
        children: [
          TopHome(user: widget.user),
          SizedBox(height: heightFactor * 10),
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
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 11 * widthFactor,
                    fontWeight: FontWeight.w500,
                    color: theme.secondaryHeaderColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: heightFactor * 10),
          OperationsPreview(
            user: widget.user,
            balance: _balance,
          ),
          SizedBox(height: heightFactor * 20),
          Center(
            child: Image.asset(
              'assets/images/ad_one.png',
              width: widthFactor * 410,
              height: heightFactor * 104.98,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: heightFactor * 20),
          OffersSection(user: widget.user),
          SizedBox(height: heightFactor * 20),
          Agents(user: widget.user),
          SizedBox(height: heightFactor * 20),
          Center(
            child: Image.asset(
              'assets/images/ad_two.png',
              width: widthFactor * 410,
              height: heightFactor * 104.98,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: heightFactor * 20),
        ],
      ),
    );
  }
}
