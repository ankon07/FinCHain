import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class FinchainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? backButtonExists;

  const FinchainAppBar({
    super.key,
    required this.title,
    this.backButtonExists,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    double widthFactor = screenWidth / 428;

    return AppBar(
      backgroundColor: theme.primaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (backButtonExists == true)
            IconButton(
              icon: const Icon(
                Icons.arrow_circle_left_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widthFactor * 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (backButtonExists == true)
            SizedBox(
              width: widthFactor * 48,
            ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
