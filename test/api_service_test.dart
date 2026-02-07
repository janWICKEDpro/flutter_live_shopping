import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_shopping/services/api_service.dart';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'assets/mock-api-data.json') {
      return jsonEncode({
        "liveEvents": [
          {
            "id": "evt_1",
            "title": "Test Event",
            "description": "Desc",
            "startTime": "2024-01-01T10:00:00Z",
            "status": "live",
            "seller": {
              "id": "s1",
              "name": "Seller",
              "storeName": "Store",
              "avatar": "",
            },
            "products": ["prod_1"],
            "thumbnailUrl": "",
          },
        ],
        "products": [
          {
            "id": "prod_1",
            "name": "Test Product",
            "description": "Desc",
            "price": 10.0,
            "images": [],
            "thumbnail": "",
            "stock": 5,
          },
        ],
        "cart": {"items": []},
        "orders": [],
      });
    }
    throw FlutterError('Asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    final string = await loadString(key);
    return ByteData.view(Uint8List.fromList(utf8.encode(string)).buffer);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiService Tests', () {
    final apiService = ApiService();

    setUpAll(() async {
      apiService.setAssetBundle(TestAssetBundle());
    });

    test('getLiveEvents returns events', () async {
      final events = await apiService.getLiveEvents();
      expect(events, isNotEmpty);
      expect(events.first.id, 'evt_1');
    });

    test('getProducts returns products for event', () async {
      final products = await apiService.getProducts('evt_1');
      expect(products, isNotEmpty);
      expect(products.first.id, 'prod_1');
    });

    test('addToCart adds item to cart', () async {
      await apiService.clearCart();
      await apiService.addToCart('prod_1', 1);
      final cart = await apiService.getCart();
      expect(cart, isNotEmpty);
      expect(cart.first.productId, 'prod_1');
      expect(cart.first.quantity, 1);
    });

    test('addToCart increments quantity', () async {
      await apiService.clearCart();
      await apiService.addToCart('prod_1', 1);
      await apiService.addToCart('prod_1', 2);
      final cart = await apiService.getCart();
      expect(cart.first.quantity, 3);
    });

    test('checkout creates order and clears cart', () async {
      await apiService.clearCart();
      await apiService.addToCart('prod_1', 1);

      final order = await apiService.checkout(
        shippingAddress: {'street': 'test'},
        paymentMethod: 'card',
      );

      expect(order.items.length, 1);

      final cart = await apiService.getCart();
      expect(cart, isEmpty);

      final orders = await apiService.getOrders();
      expect(orders, contains(predicate((o) => (o as dynamic).id == order.id)));
    });
  });
}
