import 'package:flutter/material.dart';
import 'package:root_app/models/authentication/sign_in_response_model.dart';

class UserProvider extends ChangeNotifier {
  UserInfo? user;

  UserProvider({this.user});

  updateUser(updatedUser) {
    user = updatedUser;
    notifyListeners();
  }
}
