import 'dart:developer';

import 'package:injectable/injectable.dart';


@lazySingleton
class AppSession {
  String? accessToken;
  String? refreshToken;
  String? username;

  bool get isLoggedIn => accessToken != null;

  void saveTokens({required String access, required String refresh}) {
    accessToken = access;
    refreshToken = refresh;
  }

  void saveUsername({required String username}) {
    this.username = username;
    log('AppSession: Username saved: $username');
  }

  void clear() {
    accessToken = null;
    refreshToken = null;
    username = null;
  }
}
