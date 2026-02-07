import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

enum OrderStatus { pending, completed, cancelled }

@JsonSerializable()
class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final Map<String, dynamic>? selectedVariations;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.selectedVariations,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class Order {
  final String id;
  final String userId;
  final String liveEventId;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final Map<String, dynamic> shippingAddress;

  Order({
    required this.id,
    required this.userId,
    required this.liveEventId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
  }) : assert(total >= 0, 'Total must be non-negative'),
       assert(items.isNotEmpty, 'Order must have at least one item');

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  factory Order.mock() {
    return Order(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_1',
      liveEventId: 'evt_1',
      items: [
        OrderItem(
          productId: 'prod_1',
          name: 'Mock Product',
          quantity: 1,
          price: 99.99,
        ),
      ],
      subtotal: 99.99,
      shipping: 5.00,
      total: 104.99,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      shippingAddress: {
        'street': '123 Mock St',
        'city': 'Mock City',
        'zip': '12345',
      },
    );
  }
}
