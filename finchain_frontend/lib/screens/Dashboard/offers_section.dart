import 'package:finchain_frontend/modules/svg_widget.dart';
import 'package:finchain_frontend/screens/Dashboard/round_component.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class OffersSection extends StatefulWidget {
  final User user;

  const OffersSection({super.key, required this.user});

  @override
  State<OffersSection> createState() => _OffersSectionState();
}

class _OffersSectionState extends State<OffersSection> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthFactor * 9),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthFactor * 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "My Finchain",
                  style: TextStyle(
                    fontSize: widthFactor * 11,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: heightFactor * 10),
          Row(
            children: [
              Container(
                width: widthFactor * 111,
                height: heightFactor * 128,
                decoration: BoxDecoration(
                  color: theme.canvasColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(widthFactor * 5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgWidget(
                        imageUrl: "assets/icons/offers.svg",
                        label: "My offers",
                        width: widthFactor * 30,
                        height: widthFactor * 30),
                    SizedBox(height: heightFactor * 5),
                    Text(
                      "My Offers",
                      style: TextStyle(
                          fontSize: widthFactor * 16,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor),
                    )
                  ],
                ),
              ),
              SizedBox(width: widthFactor * 10),
              Container(
                width: widthFactor * 280,
                height: heightFactor * 128,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: theme.primaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(widthFactor * 5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RoundComponent(
                          imageUrl: "assets/icons/send_money.svg",
                          label: "Emon",
                          onTap: () {},
                        ),
                        RoundComponent(
                          imageUrl: "assets/icons/mobile_recharge.svg",
                          label: "Antara",
                          onTap: () {},
                        ),
                        RoundComponent(
                          imageUrl: "assets/icons/payment.svg",
                          label: "Swapno",
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: heightFactor * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RoundComponent(
                          imageUrl: "assets/icons/send_money.svg",
                          label: "Rhydita",
                          onTap: () {},
                        ),
                        RoundComponent(
                          imageUrl: "assets/icons/payment.svg",
                          label: "IUT CDS",
                          onTap: () {},
                        ),
                        RoundComponent(
                          imageUrl: "assets/icons/mobile_recharge.svg",
                          label: "Takia",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
