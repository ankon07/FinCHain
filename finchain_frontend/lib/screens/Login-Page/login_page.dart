import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Dashboard/bottom_navbar.dart';
import 'package:flutter/material.dart';
import '../../modules/custom_appbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  // Function to log in user and fetch Firestore data
  Future<void> _loginAndFetchData() async {
    setState(() {
      isLoading = true;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavBar(
            user: User(
          name: 'Khanki Rafee',
          email: 'khankirafee@gmail.com',
          contact: '+880 1818 069420',
          imageUrl: 'assets/images/user.jpg',
        )),
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.40;

    return Scaffold(
      appBar: CustomAppBar(appbarHeight: appBarHeight),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(fontSize: 20.0),
              ),
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(fontSize: 20.0),
              ),
              style: const TextStyle(fontSize: 18.0),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading ? null : _loginAndFetchData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 15.0),
                textStyle: const TextStyle(fontSize: 22.0),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
