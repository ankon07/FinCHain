import 'package:finchain_frontend/screens/Dashboard/agent_card.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class Agents extends StatefulWidget {
  final User user;

  const Agents({super.key, required this.user});

  @override
  State<Agents> createState() => _AgentsState();
}

class _AgentsState extends State<Agents> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Container(
      margin: EdgeInsets.all(widthFactor * 9),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: theme.primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(widthFactor * 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: widthFactor * 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Finchain Agents Near You',
                  style: TextStyle(
                    fontSize: widthFactor * 11,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Add your "See All" functionality here
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: widthFactor * 8,
                      fontWeight: FontWeight.w500,
                      color: theme.secondaryHeaderColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: theme.primaryColor,
          ),
          SizedBox(height: heightFactor * 5),
          SizedBox(
            height: heightFactor * 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                AgentCard(
                  label: 'Lazz Pharma',
                  onTap: () {
                    // Add functionality for 'See Location' button here
                  },
                ),
                AgentCard(
                  label: 'Rahman Telecom',
                  onTap: () {
                    // Add functionality for 'See Location' button here
                  },
                ),
                AgentCard(
                  label: 'Lazz Pharma',
                  onTap: () {
                    // Add functionality for 'See Location' button here
                  },
                ),
                AgentCard(
                  label: 'Rahman Telecom',
                  onTap: () {
                    // Add functionality for 'See Location' button here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
