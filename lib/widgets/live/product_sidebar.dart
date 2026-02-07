import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/widgets/live/product_card_compact.dart';

class ProductSidebar extends StatelessWidget {
  final List<Product> products;
  final String? featuredProductId;
  final bool isHorizontal;

  const ProductSidebar({
    super.key,
    required this.products,
    this.featuredProductId,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort to put featured product first if exists
    final sortedProducts = List<Product>.from(products);
    if (featuredProductId != null) {
      final featuredIndex = sortedProducts.indexWhere(
        (p) => p.id == featuredProductId,
      );
      if (featuredIndex != -1) {
        final featured = sortedProducts.removeAt(featuredIndex);
        sortedProducts.insert(0, featured);
      }
    }

    return SizedBox(
      height: isHorizontal ? 200 : null,
      child: ListView.separated(
        scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
        padding: const EdgeInsets.all(16),
        itemCount: sortedProducts.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: 12, height: 12),
        itemBuilder: (context, index) {
          final product = sortedProducts[index];
          final isFeatured = product.id == featuredProductId;

          return SizedBox(
            width: isHorizontal ? 140 : double.infinity,
            height: isHorizontal ? null : 240, // Height for vertical card
            child: ProductCardCompact(product: product, isFeatured: isFeatured),
          );
        },
      ),
    );
  }
}
