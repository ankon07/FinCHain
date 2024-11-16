import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Profile/personal_info.dart';
import 'package:finchain_frontend/screens/Profile/saved_banks_preview.dart';
import 'package:finchain_frontend/screens/Profile/saved_cards_preview.dart';
import 'package:finchain_frontend/screens/Profile/top_part_profile.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Column(
      children: [
        const TopPartProfile(),
        SizedBox(height: heightFactor * 20),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widthFactor * 30),
              child: Column(
                children: [
                  PersonalInfo(user: widget.user),
                  SizedBox(height: heightFactor * 20),
                  SavedBanksPreview(user: widget.user),
                  SizedBox(height: heightFactor * 20),
                  SavedCardsPreview(user: widget.user),
                  SizedBox(height: heightFactor * 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
