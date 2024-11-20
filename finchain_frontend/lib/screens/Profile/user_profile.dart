import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Profile/personal_info.dart';
import 'package:finchain_frontend/screens/Profile/saved_banks_preview.dart';
import 'package:finchain_frontend/screens/Profile/saved_cards_preview.dart';
import 'package:finchain_frontend/screens/Profile/top_part_profile.dart';
import 'package:finchain_frontend/utils/api_service.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updatedUser = widget.user;
    getUser();
  }

  void _setLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    }
  }

  Future<void> getUser() async {
    _setLoading(true);
    try {
      final response = await apiService.fetchUserData();
      if (mounted) {
        setState(() {
          updatedUser = User(
            name: (response["first_name"] == "")
                ? widget.user.name
                : "${response["first_name"]} ${response["last_name"]}",
            contact: widget.user.contact,
            email: response["email"] == ""
                ? "not provided yet"
                : response["email"],
            imageUrl: response["profile_picture"] ?? "assets/images/user.jpg",
          );
        });
      }
      print(widget.user.contact);
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load user data. Using cached data.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: isLoading,
        message: "Loading profile...",
        child: Column(
          children: [
            TopPartProfile(
              user: updatedUser,
              onRefresh: getUser,
            ),
            SizedBox(height: heightFactor * 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: getUser,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
            ),
          ],
        ),
      ),
    );
  }
}
