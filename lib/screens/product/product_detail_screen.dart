import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/services/api_service.dart';
import 'package:flutter_live_shopping/widgets/product/add_to_cart_bar.dart';
import 'package:flutter_live_shopping/widgets/product/product_image_carousel.dart';
import 'package:flutter_live_shopping/widgets/product/product_info_section.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;

  const ProductDetailScreen({super.key, required this.id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final api = context.read<MockApiService>();
      final product = await api.getProductById(widget.id);

      if (mounted) {
        setState(() {
          _product = product;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load product: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _product != null
          ? AddToCartBar(product: _product!)
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadProduct, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_product == null) {
      return const Center(child: Text('Product not found'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return _buildDesktopLayout();
        }
        return _buildMobileLayout();
      },
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 400,
            child: ProductImageCarousel(images: _product!.images),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProductInfoSection(product: _product!),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 500,
              child: ProductImageCarousel(images: _product!.images),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductInfoSection(product: _product!),
                  const SizedBox(height: 32),
                  // On desktop, maybe move add to cart here instead of sticky bottom
                  // But for consistency with architecture, we can keep the bar or inline it.
                  // For now, it's in bottomNavigationBar, which is fine for desktop too (width limited).
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
