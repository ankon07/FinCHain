import 'package:finchain_frontend/models/Contact/contact.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/screens/Send-Money/amount_to_send.dart';
import 'package:finchain_frontend/screens/Send-Money/contact_card.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class SendMoney extends StatefulWidget {
  final User user;

  const SendMoney({super.key, required this.user});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  List<Contact> favouriteContacts = [
    Contact(name: "Sakib", number: "+880 1836 254698"),
  ];

  List<Contact> allContacts = [
    Contact(name: "Takia", number: "+880 1836 254698"),
    Contact(name: "Afifa", number: "+880 1836 254698"),
    Contact(name: "Bushra", number: "+880 1836 254698"),
    Contact(name: "Takia", number: "+880 1836 254698"),
    Contact(name: "Afifa", number: "+880 1836 254698"),
    Contact(name: "Bushra", number: "+880 1836 254698"),
    Contact(name: "Takia", number: "+880 1836 254698"),
    Contact(name: "Afifa", number: "+880 1836 254698"),
    Contact(name: "Bushra", number: "+880 1836 254698"),
    Contact(name: "Takia", number: "+880 1836 254698"),
    Contact(name: "Afifa", number: "+880 1836 254698"),
    Contact(name: "Bushra", number: "+880 1836 254698"),
  ];

  List<Contact> _filteredFavourites = [];
  List<Contact> _filteredAllContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredFavourites = favouriteContacts;
    _filteredAllContacts = allContacts;

    // Add a listener to the search controller to handle search input
    _searchController.addListener(_filterContacts);
  }

  void _filterContacts() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();

      if (_searchQuery.isEmpty) {
        // If search query is empty, show all contacts
        _filteredFavourites = favouriteContacts;
        _filteredAllContacts = allContacts;
      } else {
        // Filter contacts based on search query
        _filteredFavourites = favouriteContacts.where((contact) {
          return contact.name.toLowerCase().contains(_searchQuery) ||
              contact.number.contains(_searchQuery);
        }).toList();

        _filteredAllContacts = allContacts.where((contact) {
          return contact.name.toLowerCase().contains(_searchQuery) ||
              contact.number.contains(_searchQuery);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Send Money",
        backButtonExists: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(widthFactor * 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Receiver",
                  style: TextStyle(
                    fontSize: widthFactor * 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: heightFactor * 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthFactor * 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E3E8),
                    borderRadius: BorderRadius.circular(widthFactor * 30),
                  ),
                  width: double.infinity,
                  height: heightFactor * 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.search, color: Colors.black54),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: heightFactor * 10),
          const Divider(
            color: Color(0xFFD2B48C),
            thickness: 5,
          ),
          SizedBox(height: heightFactor * 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthFactor * 20),
            child: Text(
              "Account Numbers",
              style: TextStyle(
                fontSize: widthFactor * 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: heightFactor * 10),
          const Divider(
            color: Color(0xFFD2B48C),
            thickness: 5,
          ),
          SizedBox(height: heightFactor * 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthFactor * 20),
                    child: Text(
                      "Favourites",
                      style: TextStyle(
                        fontSize: widthFactor * 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Column(
                    children: _filteredFavourites
                        .map((contact) => ContactCard(
                              contact: contact,
                              buttonAction: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AmountToSend(contact: contact),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                  SizedBox(height: heightFactor * 10),
                  const Divider(
                    color: Color(0xFFD2B48C),
                    thickness: 2,
                  ),
                  SizedBox(height: heightFactor * 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthFactor * 20),
                    child: Text(
                      "All contacts",
                      style: TextStyle(
                        fontSize: widthFactor * 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Column(
                    children: _filteredAllContacts
                        .map((contact) => ContactCard(
                              contact: contact,
                              buttonAction: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AmountToSend(contact: contact),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                  SizedBox(height: heightFactor * 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: heightFactor * 40,
        color: theme.primaryColor,
      ),
    );
  }
}
