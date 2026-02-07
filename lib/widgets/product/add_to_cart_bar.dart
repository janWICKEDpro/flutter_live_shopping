import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/providers/cart_provider.dart';
import 'package:flutter_live_shopping/widgets/product/quantity_selector.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AddToCartBar extends StatefulWidget {
  final Product product;

  const AddToCartBar({super.key, required this.product});

  @override
  State<AddToCartBar> createState() => _AddToCartBarState();
}

class _AddToCartBarState extends State<AddToCartBar> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Listen to cart provider to check if item is already in cart
    final cart = context.watch<CartProvider>();

    // indexWhere is safer
    final cartItemIndex = cart.items.indexWhere(
      (item) => item.product.id == widget.product.id,
    );
    final int quantityInCart = cartItemIndex != -1
        ? cart.items[cartItemIndex].quantity
        : 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (quantityInCart > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$quantityInCart already in cart',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                QuantitySelector(
                  quantity: _quantity,
                  maxQuantity: widget.product.stock,
                  onChanged: (value) {
                    setState(() {
                      _quantity = value;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: widget.product.stock > 0
                          ? () {
                              context.read<CartProvider>().addToCart(
                                widget.product,
                                quantity: _quantity,
                              );

                              toastification.show(
                                context: context,
                                type: ToastificationType.success,
                                style: ToastificationStyle.fillColored,
                                title: const Text('Added to Cart'),
                                description: Text(
                                  'Successfully added $_quantity ${widget.product.name}',
                                ),
                                alignment: Alignment.topCenter,
                                autoCloseDuration: const Duration(seconds: 3),
                                animationBuilder:
                                    (context, animation, alignment, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                ),
                                primaryColor: AppColors.success,
                                foregroundColor: Colors.white,
                                showProgressBar: false,
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
