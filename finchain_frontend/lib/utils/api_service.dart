import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://192.168.0.195:8000/api';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<http.Response> register(String mobileNumber, String pin) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile_number': mobileNumber, 'pin': pin}),
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to sign up!');
    }
  }

  Future<http.Response> login(String mobileNumber, String pin) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile_number': mobileNumber, 'pin': pin}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Store the access token
      await storage.write(key: 'access_token', value: data['access']);
      await storage.write(key: 'refresh_token', value: data['refresh']);
      return response;
    } else {
      throw Exception('Failed to sign in!');
    }
  }

  // Transactions

  Future<String> fetchBalance() async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/stellar_accounts/check_balance/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String balanceStr = data['balances'][0]['balance'];
      if (!balanceStr.contains('.')) {
        balanceStr = '$balanceStr.00';
      } else {
        int dotIndex = balanceStr.indexOf('.');
        int digitsAfterDecimal = balanceStr.length - dotIndex - 1;
        if (digitsAfterDecimal > 2) {
          balanceStr = balanceStr.substring(0, dotIndex + 3);
        } else if (digitsAfterDecimal < 2) {
          balanceStr = '${balanceStr}0';
        }
      }
      return balanceStr;
    } else {
      throw Exception('Failed to fetch data!');
    }
  }

  Future<String> sendPayment(
      String mobileNumber, String amount, String reference) async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.post(
      Uri.parse('$baseUrl/stellar_accounts/send_payment/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'mobile_number': mobileNumber,
        'amount': amount,
        'memo': reference,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String fee = data["response"]["fee_charged"];
      return fee;
    } else {
      throw Exception('Failed to sign in!');
    }
  }

  Future<String> fundAccount(String mobileNumber) async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.post(
      Uri.parse('$baseUrl/stellar_accounts/fund_account/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'mobile_number': mobileNumber}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String amount = data["response"]["max_fee"];
      return amount;
    } else {
      throw Exception('Failed to Fund or Already Funded!');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    try {
      // Retrieve the access token
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing!');
      }

      // Make the API request
      final response = await http.get(
        Uri.parse('$baseUrl/stellar_accounts/transaction_history/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // Check for success response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure the transactions key exists and is a list
        if (data is Map<String, dynamic> && data['transactions'] is List) {
          // Filter valid transactions
          List<Map<String, dynamic>> transactions =
              List<Map<String, dynamic>>.from(
            data['transactions'].where((transaction) {
              return transaction['sender_mobile'] != null &&
                  transaction['receiver_mobile'] != null &&
                  double.tryParse(transaction['amount'].toString()) != 0;
            }),
          );
          return transactions;
        } else {
          throw Exception(
              'Unexpected response format: "transactions" key is missing or invalid!');
        }
      } else {
        print('Failed response: ${response.body}');
        throw Exception('Failed to fetch data! HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchTransactions: $e');
      throw Exception('Error fetching transactions: $e');
    }
  }

  // Profile Related

  Future<Map<String, dynamic>> fetchUserData() async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/user_profiles/retrieve_profile/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["first_name"] == null) {
        data["first_name"] = "";
      }

      if (data["last_name"] == null) {
        data["last_name"] = "";
      }

      if (data["email"] == null) {
        data["email"] = "";
      }

      if (data["profile_picture"] == null) {
        data["profile_picture"] = "assets/images/user.jpg";
      }

      return data;
    } else {
      throw Exception('Failed to fetch data!');
    }
  }

  Future<Map<String, dynamic>> updateUserData(
    String firstName,
    String lastName,
    String email,
  ) async {
    final accessToken = await storage.read(key: 'access_token');

    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('$baseUrl/user_profiles/update_profile/'),
    );

    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['email'] = email;
    request.files.add(await http.MultipartFile.fromPath(
      'profile_picture',
      'assets/images/user.jpg',
    ));

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to update user data: $responseBody');
    }
  }
}
