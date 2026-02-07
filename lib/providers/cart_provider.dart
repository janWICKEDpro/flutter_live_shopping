import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/services/api_service.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _apiService;

  CartProvider(this._apiService);
}
