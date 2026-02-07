import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';
import 'package:flutter_live_shopping/providers/cart_provider.dart';
import 'package:flutter_live_shopping/services/api_service.dart';
import 'package:flutter_live_shopping/widgets/checkout/checkout_cart_summary.dart';
import 'package:flutter_live_shopping/widgets/checkout/payment_method_selector.dart';
import 'package:flutter_live_shopping/widgets/checkout/shipping_form.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _processCheckout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final shippingAddress = {
        'name': _nameController.text,
        'email': _emailController.text,
        'street': _streetController.text,
        'city': _cityController.text,
        'zip': _zipController.text,
      };

      await context.read<MockApiService>().checkout(
        shippingAddress: shippingAddress,
        paymentMethod: _selectedPaymentMethod.name,
      );

      // Clear cart locally via provider (MockApiService already clears its internal cart,
      // but Provider needs to clear state too - or re-fetch).
      // Let's assume Provider should clear.
      if (mounted) {
        context.read<CartProvider>().clearCart();

        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: const Text('Order Placed Successfully!'),
          description: const Text('Thank you for your purchase.'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
          primaryColor: AppColors.success,
          foregroundColor: Colors.white,
        );

        context.go('/checkout/success');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Checkout failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CheckoutCartSummary(),
                    const SizedBox(height: 24),
                    ShippingForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      streetController: _streetController,
                      cityController: _cityController,
                      zipController: _zipController,
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    PaymentMethodSelector(
                      selectedMethod: _selectedPaymentMethod,
                      onChanged: (method) {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
