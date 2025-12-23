import 'package:flutter/material.dart';
import '../models/user.dart';
import '../methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Users? _user; // This starts as null
  final AuthMethods _authMethods = AuthMethods();

  // Change: Remove the '!' and add '?' to the return type
  Users? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      Users user = await _authMethods.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      print("Error refreshing user: $e");
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
