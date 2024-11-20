import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.0.195:8000/api';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<http.Response> register(String mobileNumber, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'mobile_number': mobileNumber,
          'pin': pin,
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> login(String mobileNumber, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'mobile_number': mobileNumber,
          'pin': pin,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await storage.write(key: 'access_token', value: data['access']);
        await storage.write(key: 'refresh_token', value: data['refresh']);
        return response;
      } else {
        throw Exception('Failed to sign in!');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fetchBalance() async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<String> sendPayment(
      String mobileNumber, String amount, String reference) async {
    try {
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
        throw Exception('Failed to process payment!');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fundAccount(String mobileNumber) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    try {
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing!');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/stellar_accounts/transaction_history/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> && data['transactions'] is List) {
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
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
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

        print(data);
        return data;
      } else {
        throw Exception('Failed to fetch user data!');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUserData({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    try {
      final accessToken = await storage.read(key: 'access_token');

      final response = await http.patch(
        Uri.parse('$baseUrl/user_profiles/update_profile/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (email != null) 'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update user data');
      }
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }
}
