import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/models/cart_item.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/services/api_service.dart';

class CartProvider extends ChangeNotifier {
  final MockApiService _apiService;
  final List<CartItem> _items = [];
  bool _isLoading = false;

  CartProvider(this._apiService);

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  double get total =>
      _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      // In a real app, fetch from API
      // For mock, we might just keep local state perfectly fine or fetch initial
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(
    Product product, {
    int quantity = 1,
    Map<String, String>? variations,
  }) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      final existingItem = _items[existingIndex];
      _items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      _items.add(
        CartItem(
          id: 'cart_item_${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          product: product,
          quantity: quantity,
          selectedVariations: variations,
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        removeFromCart(itemId);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
