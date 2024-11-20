import 'package:finchain_frontend/screens/Login-Page/login_page.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finchain_frontend/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FinchainApp());
}

class FinchainApp extends StatelessWidget {
  const FinchainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Finchain',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(body: LoginPage()),
      ),
    );
  }
}