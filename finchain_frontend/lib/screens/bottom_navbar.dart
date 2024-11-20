import 'package:finchain_frontend/modules/coming_soon.dart';
import 'package:finchain_frontend/screens/Dashboard/dashboard.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Notifications/notifications.dart';
import 'package:finchain_frontend/screens/Profile/user_profile.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final User user;

  const BottomNavBar({super.key, required this.user});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  ThemeData theme = AppTheme.getTheme();

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appScreens = [
      Dashboard(user: widget.user),
      ComingSoon(
        user: widget.user,
        backButtonExists: false,
      ),
      Notifications(user: widget.user),
      UserProfile(user: widget.user),
    ];

    return Scaffold(
      body: appScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.disabledColor,
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_qr_code_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_qr_code_filled),
                label: "QR"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none_sharp),
                activeIcon: Icon(Icons.notifications),
                label: "Notifications"),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
                label: "Profile"),
          ]),
    );
  }
}
