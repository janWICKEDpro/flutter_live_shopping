import 'package:json_annotation/json_annotation.dart';
import 'product.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  final String id;
  final String productId;
  final Product
  product; // Note: In real app, might just store ID, but for mock we often store full object or hydrate it
  final int quantity;
  final Map<String, String>? selectedVariations;

  CartItem({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
    this.selectedVariations,
  });

  double get total => product.currentPrice * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    Product? product,
    int? quantity,
    Map<String, String>? selectedVariations,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedVariations: selectedVariations ?? this.selectedVariations,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
