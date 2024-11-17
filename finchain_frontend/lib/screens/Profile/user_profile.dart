import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Profile/personal_info.dart';
import 'package:finchain_frontend/screens/Profile/saved_banks_preview.dart';
import 'package:finchain_frontend/screens/Profile/saved_cards_preview.dart';
import 'package:finchain_frontend/screens/Profile/top_part_profile.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ApiService apiService = ApiService();
  late User updatedUser;
  bool isLoading = true; // Start in loading state

  @override
  void initState() {
    super.initState();
    getUser(); // Start the data-fetching process
  }

  Future<void> getUser() async {
    try {
      final response = await apiService.fetchUserData();
      setState(() {
        updatedUser = User(
          name: (response["first_name"] == "")
              ? widget.user.name
              : "${response["first_name"]} ${response["last_name"]}",
          contact: widget.user.contact,
          email:
              response["email"] == "" ? "not provided yet" : response["email"],
          imageUrl: response["profile_picture"],
        );
      });
    } catch (e) {
      // Handle the error by falling back to the provided user data
      setState(() {
        updatedUser = widget.user;
      });
    } finally {
      // Always stop the loading indicator
      print(updatedUser.name);
      print(updatedUser.contact);
      print(updatedUser.email);
      print(updatedUser.imageUrl);
      setState(() {
        isLoading = false;
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

    // Show loading spinner if data is still loading
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        TopPartProfile(user: updatedUser),
        SizedBox(height: heightFactor * 20),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widthFactor * 30),
              child: Column(
                children: [
                  PersonalInfo(user: updatedUser),
                  SizedBox(height: heightFactor * 20),
                  SavedBanksPreview(user: updatedUser),
                  SizedBox(height: heightFactor * 20),
                  SavedCardsPreview(user: updatedUser),
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
