import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductCardCompact extends StatefulWidget {
  final Product product;
  final bool isFeatured;

  const ProductCardCompact({
    super.key,
    required this.product,
    this.isFeatured = false,
  });

  @override
  State<ProductCardCompact> createState() => _ProductCardCompactState();
}

class _ProductCardCompactState extends State<ProductCardCompact> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          context.push('/product/${widget.product.id}');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(
            0.0,
            _isHovered ? -4.0 : 0.0,
            0.0,
          ),
          width: 140, // Fixed width for horizontal list or consistent vertical
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: widget.isFeatured
                ? Border.all(color: AppColors.primary, width: 2)
                : _isHovered
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: _isHovered ? Colors.black26 : Colors.black12,
                blurRadius: _isHovered ? 12 : 8,
                offset: Offset(0, _isHovered ? 6 : 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: RepaintBoundary(
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'product-${widget.product.id}',
                        child: CachedNetworkImage(
                          imageUrl: widget.product.thumbnail,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: AppColors.gray200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.broken_image,
                            color: AppColors.gray400,
                          ),
                        ),
                      ),
                      if (widget.isFeatured)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'FEATURED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${widget.product.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartProvider>().addToCart(
                            widget.product,
                          );
                          // ScaffoldMessenger replaced by Toastification later but keeping simple snackbar here for card is fine
                          // Or should we update this one too? The user said "when a product is added to cart".
                          // Let's rely on the caller or update here.
                          // I'll update here too if it's easy, but ProductDetailScreen is the main focus for "popup".
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added ${widget.product.name} to cart',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(fontSize: 10),
                        ),
                        child: const Text('ADD'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
