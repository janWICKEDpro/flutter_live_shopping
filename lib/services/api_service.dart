import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_live_shopping/models/live_event.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/models/order.dart';
import 'package:flutter_live_shopping/models/cart_item.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  AssetBundle _bundle = rootBundle;

  @visibleForTesting
  void setAssetBundle(AssetBundle bundle) {
    _bundle = bundle;
    _mockData = null; // Clear cache to allow reloading
  }

  Map<String, dynamic>? _mockData;
  final List<CartItem> _cart = [];
  List<Order> _orders = [];
  final String _currentUserId = 'user_001';

  Future<void> _loadMockData() async {
    if (_mockData != null) return;

    try {
      final jsonString = await _bundle.loadString('assets/mock-api-data.json');
      final decoded = json.decode(jsonString);
      _mockData = decoded is Map<String, dynamic> ? decoded : {};

      if (_mockData!['orders'] is List) {
        _orders = (_mockData!['orders'] as List)
            .whereType<Map<String, dynamic>>()
            .map((json) => Order.fromJson(json))
            .toList();
      }

      // // Initialize cart from mock data if needed
      // if (_mockData!['cart'] != null && _mockData!['cart'] is List) {
      //   final cartData = _mockData!['cart'] as List;
      //   if (cartData.isNotEmpty) {
      //     // Get the first user's cart (for demo purposes)
      //     final userCart = cartData.first;
      //     if (userCart['items'] != null) {
      //       final cartItems = userCart['items'] as List;
      //       log("cartItems: $cartItems");
      //       // Hydrate cart items with product details
      //       for (var item in cartItems) {
      //         final productId = item['productId'];
      //         final product = await _getProductByIdInternal(productId);
      //         if (product != null) {
      //           _cart.add(CartItem.fromJson(item).copyWith(product: product));
      //         }
      //       }
      //     }
      //   }
      // }
    } catch (e) {
      log('Error loading mock data: $e');
      rethrow;
    }
  }

  // Helper to get product synchronously if data is loaded (for internal use)
  Future<Product?> _getProductByIdInternal(String id) async {
    final productsData = _mockData!['products'] as List;
    try {
      final productJson = productsData.firstWhere(
        (p) => p['id'] == id,
        orElse: () => null,
      );
      return productJson != null ? Product.fromJson(productJson) : null;
    } catch (e) {
      return null;
    }
  }

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // --- Live Events ---

  Future<List<LiveEvent>> getLiveEvents() async {
    await _loadMockData();
    await _simulateNetworkDelay();

    final eventsData = _mockData!['liveEvents'] as List;
    final productsData = _mockData!['products'] as List;
    return eventsData.map((eventJson) {
      try {
        // Hydrate products
        final productIds = (eventJson['products'] as List).cast<String>();
        final products = productIds
            .map((id) {
              final productJson = productsData.firstWhere(
                (p) => p['id'] == id,
                orElse: () => null,
              );
              return productJson != null ? Product.fromJson(productJson) : null;
            })
            .whereType<Product>()
            .toList();

        // Hydrate featured product
        Product? featuredProduct;
        if (eventJson['featuredProduct'] != null) {
          final featuredId = eventJson['featuredProduct'] as String;
          final featuredJson = productsData.firstWhere(
            (p) => p['id'] == featuredId,
            orElse: () => null,
          );
          if (featuredJson != null) {
            featuredProduct = Product.fromJson(featuredJson);
          }
        }

        return LiveEvent.fromJson({
          ...eventJson,
          'products': products.map((p) => p.toJson()).toList(),
          'featuredProduct': featuredProduct?.toJson(),
        });
      } catch (e) {
        log('Error parsing event ${eventJson['id']}: $e');
        rethrow;
      }
    }).toList();
  }

  Future<LiveEvent?> getLiveEventById(String id) async {
    // In a real app, this might be a separate API call.
    // Here we can just filter the list.
    final events = await getLiveEvents();
    try {
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  // --- Products ---

  Future<List<Product>> getProducts(String eventId) async {
    final event = await getLiveEventById(eventId);
    return event?.products ?? [];
  }

  Future<Product?> getProductById(String id) async {
    await _loadMockData();
    await _simulateNetworkDelay();
    return _getProductByIdInternal(id);
  }

  // --- Cart ---

  Future<List<CartItem>> getCart() async {
    await _loadMockData();
    await _simulateNetworkDelay();
    return List.from(_cart);
  }

  Future<void> addToCart(
    String productId,
    int quantity, {
    Map<String, String>? variations,
  }) async {
    await _loadMockData();
    await _simulateNetworkDelay();

    final product = await _getProductByIdInternal(productId);
    if (product == null) {
      throw Exception('Product not found');
    }

    final existingIndex = _cart.indexWhere(
      (item) =>
          item.productId == productId &&
          _mapsEqual(item.selectedVariations, variations),
    );

    if (existingIndex >= 0) {
      _cart[existingIndex] = _cart[existingIndex].copyWith(
        quantity: _cart[existingIndex].quantity + quantity,
      );
    } else {
      _cart.add(
        CartItem(
          id: 'cart_item_${DateTime.now().millisecondsSinceEpoch}',
          productId: productId,
          product: product,
          quantity: quantity,
          selectedVariations: variations,
        ),
      );
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    await _loadMockData();
    await _simulateNetworkDelay();
    _cart.removeWhere((item) => item.id == cartItemId);
  }

  Future<void> clearCart() async {
    await _loadMockData();
    await _simulateNetworkDelay();
    _cart.clear();
  }

  bool _mapsEqual(Map<String, String>? a, Map<String, String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (var key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  // --- Orders ---

  Future<List<Order>> getOrders() async {
    await _loadMockData();
    await _simulateNetworkDelay();
    return _orders.where((order) => order.userId == _currentUserId).toList();
  }

  Future<Order> checkout({
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
  }) async {
    await _loadMockData();
    await _simulateNetworkDelay();

    if (_cart.isEmpty) {
      throw Exception('Cart is empty');
    }

    final subtotal = _cart.fold<double>(
      0,
      (sum, item) => sum + (item.product.currentPrice * item.quantity),
    );
    const shipping = 5.99;
    final total = subtotal + shipping;

    final order = Order(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUserId,
      liveEventId: '', // Context dependent
      items: _cart
          .map(
            (item) => OrderItem(
              productId: item.productId,
              name: item.product.name,
              quantity: item.quantity,
              price: item.product.currentPrice,
              selectedVariations: item.selectedVariations,
            ),
          )
          .toList(),
      subtotal: subtotal,
      shipping: shipping,
      total: total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      shippingAddress: shippingAddress,
    );

    _orders.add(order);
    _cart.clear();

    return order;
  }
}
