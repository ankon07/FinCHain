import 'dart:convert';

import 'package:finchain_frontend/providers/user_provider.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/logo.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
import 'package:finchain_frontend/screens/bottom_navbar.dart';
import 'package:finchain_frontend/screens/Login-Page/register_page.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ThemeData theme = AppTheme.getTheme();
  final ApiService apiService = ApiService();
  bool isLoading = false;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  Future<void> _handleSignIn() async {
    setState(() {
      isLoading = true;
    });

    String mobile = _mobileController.text.trim();
    String pin = _pinController.text.trim();

    // Input validation
    if (mobile.isEmpty || pin.isEmpty) {
      _showSnackBar('Please fill in all fields');
      _setLoading(false);
      return;
    }

    if (mobile.length != 11 || !RegExp(r'^\d+$').hasMatch(mobile)) {
      _showSnackBar('Mobile number must be 11 digits and numeric');
      _setLoading(false);
      return;
    }

    if (pin.length != 4 || !RegExp(r'^\d+$').hasMatch(pin)) {
      _showSnackBar('PIN must be 4 digits and numeric');
      _setLoading(false);
      return;
    }

    try {
      final response = await apiService.login(mobile, pin);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        _setLoading(false);
        _showSnackBar('Sign in successful!');

        final jsonUser = await apiService.fetchUserData();
        User user = User.fromJson(jsonUser, mobile);

        await Provider.of<UserProvider>(context, listen: false).setUser(user);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(
              user: user,
            ),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Server error occurred';
        _showSnackBar('Error: $errorMessage');
        _setLoading(false);
      }
    } catch (e) {
      // Handle client-side/network errors
      debugPrint('Error: $e');
      _showSnackBar(
          'An error occurred. Please check your internet connection and try again.');
      _setLoading(false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    // double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        message: "Signing in...",
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30, right: 35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome\nBack',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                  const Spacer(),
                  Logo(size: heightFactor * 50)
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: screenHeight * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Mobile Number",
                              hintStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: _pinController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 4,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              counterText: "", // Hides max length counter
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "4-digit PIN",
                              hintStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: theme.canvasColor,
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: _handleSignIn,
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot PIN?',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}
