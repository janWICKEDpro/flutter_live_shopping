// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  productId: json['productId'] as String,
  name: json['name'] as String,
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  selectedVariations: json['selectedVariations'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'productId': instance.productId,
  'name': instance.name,
  'quantity': instance.quantity,
  'price': instance.price,
  'selectedVariations': instance.selectedVariations,
};

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['id'] as String,
  userId: json['userId'] as String,
  liveEventId: json['liveEventId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotal: (json['subtotal'] as num).toDouble(),
  shipping: (json['shipping'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  shippingAddress: json['shippingAddress'] as Map<String, dynamic>,
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'liveEventId': instance.liveEventId,
  'items': instance.items,
  'subtotal': instance.subtotal,
  'shipping': instance.shipping,
  'total': instance.total,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'shippingAddress': instance.shippingAddress,
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};
