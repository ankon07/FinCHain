import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Profile/profile_settings.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class TopPartProfile extends StatefulWidget {
  final User user;
  final Future<void> Function() onRefresh;

  const TopPartProfile({
    super.key,
    required this.user,
    required this.onRefresh,
  });

  @override
  State<TopPartProfile> createState() => _TopPartProfileState();
}

class _TopPartProfileState extends State<TopPartProfile> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: screenWidth,
                  height: heightFactor * 150,
                  color: theme.primaryColor,
                  padding: EdgeInsets.only(
                    right: widthFactor * 22,
                    top: widthFactor * 55,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileSettings(),
                            ),
                          );
                          if (result == true) {
                            widget.onRefresh();
                          }
                        },
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: widthFactor * 36,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: heightFactor * 150,
                  color: Colors.white,
                ),
              ],
            ),
            Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: widthFactor * 50,
                      bottom: widthFactor * 10,
                    ),
                    width: widthFactor * 218,
                    height: widthFactor * 218,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: widthFactor * 10,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        widget.user.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.user.name,
                    style: TextStyle(
                      fontSize: widthFactor * 24,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
