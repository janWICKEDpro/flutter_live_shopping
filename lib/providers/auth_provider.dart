import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);
}
