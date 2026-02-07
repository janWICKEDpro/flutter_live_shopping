import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/providers/cart_provider.dart';
import 'package:flutter_live_shopping/widgets/product/quantity_selector.dart';
import 'package:provider/provider.dart';

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
        child: Row(
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added $_quantity ${widget.product.name} to cart',
                              ),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                onPressed: () {
                                  // Open cart drawer?
                                  // For now, simpler notification
                                  // Ideally trigger drawer open via callback or global key
                                },
                              ),
                            ),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
