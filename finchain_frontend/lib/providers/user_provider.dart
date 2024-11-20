import 'package:finchain_frontend/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:finchain_frontend/models/User/user.dart';
import 'package:finchain_frontend/utils/api_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> setUser(User user) async {
    _user = user;
    notifyListeners();
  }

  Future<void> updateUser({
    String? name,
    String? email,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedData = await _apiService.updateUserData(
        firstName: name != null ? Utils.splitName(name)['first_name'] : null,
        lastName: name != null ? Utils.splitName(name)['last_name'] : null,
        email: email,
      );

      if (_user != null) {
        _user = User(
          name: name ?? _user!.name,
          email: email ?? _user!.email,
          contact: _user!.contact,
          imageUrl: updatedData['profile_picture'] ?? _user!.imageUrl,
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> refreshUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userData = await _apiService.fetchUserData();
      _user = User.fromJson(userData, _user!.contact);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
