import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthCredentials {
  String username, password;

  AuthCredentials(String username, String password) {
    this.username = username;
    this.password = sha256.convert(utf8.encode(password)).toString();
  }
}

class AuthState {
  final bool isLoggedIn;
  final String token;

  AuthState({this.isLoggedIn = false, this.token});
}
