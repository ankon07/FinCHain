import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
import 'package:finchain_frontend/screens/Cross-Border/finchain_transfer_details.dart';
import 'package:finchain_frontend/utils/theme.dart';
import 'package:flutter/material.dart';

class FinchainToFinchain extends StatefulWidget {
  final User user;
  final String balance;

  const FinchainToFinchain({
    super.key,
    required this.user,
    required this.balance,
  });

  @override
  State<FinchainToFinchain> createState() => _FinchainToFinchainState();
}

class _FinchainToFinchainState extends State<FinchainToFinchain> {
  String? selectedCountry;
  String? selectedCurrency;
  double? conversionRate;
  bool showNextButton = false;
  ThemeData theme = AppTheme.getTheme();
  final List<Map<String, dynamic>> countries = [
    {"name": "United States", "code": "US", "currency": "USD", "rate": 110.25},
    {"name": "United Kingdom", "code": "UK", "currency": "GBP", "rate": 139.50},
    {"name": "European Union", "code": "EU", "currency": "EUR", "rate": 118.75},
    {"name": "Australia", "code": "AU", "currency": "AUD", "rate": 71.80},
    {"name": "Canada", "code": "CA", "currency": "CAD", "rate": 81.45},
  ];
  bool _isLoading = false;

  List<String> getCurrenciesForCountry(String country) {
    final countryData = countries.firstWhere(
      (c) => c["name"] == country,
      orElse: () => {"currency": ""},
    );
    return [countryData["currency"]];
  }

  void updateConversionRate() {
    if (selectedCountry != null && selectedCurrency != null) {
      final countryData = countries.firstWhere(
        (c) => c["name"] == selectedCountry,
        orElse: () => {"rate": 0.0},
      );
      setState(() {
        conversionRate = countryData["rate"];
        showNextButton = true;
      });
    }
  }

  void _setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    }
  }

  Future<void> _handleNext() async {
    _setLoading(true);
    try {
      // Simulate API call to get conversion rate
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FinchainTransferDetails(
            user: widget.user,
            balance: widget.balance,
            selectedCountry: selectedCountry!,
            selectedCurrency: selectedCurrency!,
            conversionRate: conversionRate!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    double heightFactor = screenHeight / 926;

    return Scaffold(
      appBar: const FinchainAppBar(
        title: "Cross Border",
        backButtonExists: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: "Loading details...",
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(heightFactor * 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Country and Currency",
                style: TextStyle(
                  fontSize: heightFactor * 18,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(height: heightFactor * 20),
              Container(
                padding: EdgeInsets.all(heightFactor * 15),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCountry,
                      decoration: InputDecoration(
                        labelText: "Select Country",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      items: countries
                          .map((country) => DropdownMenuItem<String>(
                                value: country["name"] as String,
                                child: Text(country["name"] as String),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                          selectedCurrency = null;
                        });
                        updateConversionRate();
                      },
                    ),
                    SizedBox(height: heightFactor * 20),
                    if (selectedCountry != null)
                      DropdownButtonFormField<String>(
                        value: selectedCurrency,
                        decoration: InputDecoration(
                          labelText: "Select Currency",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        items: getCurrenciesForCountry(selectedCountry!)
                            .map((currency) => DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(currency),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCurrency = value;
                          });
                          updateConversionRate();
                        },
                      ),
                    SizedBox(height: heightFactor * 20),
                    if (conversionRate != null)
                      Container(
                        padding: EdgeInsets.all(heightFactor * 10),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Conversion Rate:",
                              style: TextStyle(
                                fontSize: heightFactor * 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "1 ${selectedCurrency} = ${conversionRate?.toStringAsFixed(2)} BDT",
                              style: TextStyle(
                                fontSize: heightFactor * 16,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: heightFactor * 50),
              if (showNextButton)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding:
                          EdgeInsets.symmetric(vertical: heightFactor * 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: heightFactor * 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
