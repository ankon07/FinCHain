import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Profile/bank_or_card_info.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class CardInfo {
  final String holderName;
  final String cardNo;
  final String imgaeUrl;

  CardInfo(this.holderName, this.cardNo, this.imgaeUrl);
}

class SavedCardsPreview extends StatelessWidget {
  final User user;

  const SavedCardsPreview({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    List<CardInfo> savedCards = [
      CardInfo("Khanki Rafee", "4205 2365 8549 6321", "assets/images/user.jpg"),
      CardInfo("Khanki Rafee", "4205 2365 8549 6321", "assets/images/user.jpg"),
      CardInfo("Khanki Rafee", "4205 2365 8549 6321", "assets/images/user.jpg"),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Saved Cards",
              style: TextStyle(
                fontSize: widthFactor * 20,
                fontWeight: FontWeight.w500,
                color: theme.secondaryHeaderColor,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                fontSize: 11 * widthFactor,
                fontWeight: FontWeight.w500,
                color: theme.secondaryHeaderColor,
              ),
            ),
          ],
        ),
        SizedBox(height: heightFactor * 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: theme.primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          padding: EdgeInsets.symmetric(vertical: widthFactor * 4),
          child: Column(
            children: savedCards
                .map((cardInfo) => BankOrCardInfo(
                      name: cardInfo.holderName,
                      number: cardInfo.cardNo,
                      imageUrl: cardInfo.imgaeUrl,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
