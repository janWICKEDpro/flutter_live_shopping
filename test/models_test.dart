import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_shopping/models/live_event.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/models/chat_message.dart';
import 'package:flutter_live_shopping/models/order.dart';
import 'package:flutter_live_shopping/models/user.dart';

void main() {
  group('Model Validation Tests', () {
    test('LiveEvent throws assertion error if endTime is before startTime', () {
      expect(
        () => LiveEvent(
          id: '1',
          title: 'Test',
          description: 'Desc',
          startTime: DateTime.now(),
          endTime: DateTime.now().subtract(const Duration(hours: 1)),
          status: LiveEventStatus.scheduled,
          seller: Seller(
            id: 's1',
            name: 'Seller',
            storeName: 'Store',
            avatar: '',
          ),
          thumbnailUrl: '',
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Product throws assertion error for negative price', () {
      expect(
        () => Product(
          id: '1',
          name: 'Product',
          description: 'Desc',
          price: -10.0,
          images: [],
          thumbnail: '',
          stock: 10,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('ChatMessage throws assertion error for empty message', () {
      expect(
        () => ChatMessage(
          id: '1',
          senderId: 'u1',
          senderName: 'User',
          message: '',
          timestamp: DateTime.now(),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Order throws assertion error for empty items', () {
      expect(
        () => Order(
          id: '1',
          userId: 'u1',
          liveEventId: 'e1',
          items: [],
          subtotal: 0,
          shipping: 0,
          total: 0,
          status: OrderStatus.pending,
          createdAt: DateTime.now(),
          shippingAddress: {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('User throws assertion error for invalid email', () {
      expect(
        () => User(
          id: '1',
          email: 'invalid-email',
          name: 'User',
          avatar: '',
          createdAt: DateTime.now(),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('Mock Factory Tests', () {
    test('LiveEvent.mock() creates valid object', () {
      final event = LiveEvent.mock();
      expect(event.id, isNotEmpty);
      expect(event.title, equals('Mock Event'));
    });

    test('Product.mock() creates valid object', () {
      final product = Product.mock();
      expect(product.id, isNotEmpty);
      expect(product.price, greaterThanOrEqualTo(0));
    });

    test('ChatMessage.mock() creates valid object', () {
      final message = ChatMessage.mock();
      expect(message.message, isNotEmpty);
    });

    test('Order.mock() creates valid object', () {
      final order = Order.mock();
      expect(order.items, isNotEmpty);
      expect(order.total, greaterThanOrEqualTo(0));
    });

    test('User.mock() creates valid object', () {
      final user = User.mock();
      expect(user.email, contains('@'));
    });
  });
}
