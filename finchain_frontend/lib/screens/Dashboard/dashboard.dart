import 'package:finchain_frontend/screens/Dashboard/agents.dart';
import 'package:finchain_frontend/screens/Dashboard/offers_section.dart';
import 'package:finchain_frontend/screens/Dashboard/operations_preview.dart';
import 'package:finchain_frontend/screens/Dashboard/top_home.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';

class Dashboard extends StatefulWidget {
  final User user;

  const Dashboard({super.key, required this.user});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ThemeData theme = AppTheme.getTheme();
  ApiService apiService = ApiService();
  bool isLoading = false;

  String _balance = "0.00";

  @override
  void initState() {
    super.initState();
    getBalance();
  }

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

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

  Future<void> fetchImageUrl() async {}

  Future<void> _logout() async {}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return LoadingOverlay(
      isLoading: isLoading,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TopHome(user: widget.user),
            SizedBox(height: heightFactor * 10),
            OperationsPreview(
              user: widget.user,
              balance: _balance,
            ),
            SizedBox(height: heightFactor * 20),
            Center(
              child: Image.asset(
                'assets/images/ad_three.png',
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
      ),
    );
  }
}
