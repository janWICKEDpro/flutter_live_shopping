import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;

  const ProductImageCarousel({super.key, required this.images});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        color: AppColors.gray200,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported,
          size: 64,
          color: AppColors.gray400,
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final widget = CachedNetworkImage(
              imageUrl: this.widget.images[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.gray200,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            );

            // Wrap first image in Hero for smooth transition from product card
            if (index == 0) {
              return Hero(
                tag: 'product-${this.widget.images[index]}',
                child: widget,
              );
            }
            return widget;
          },
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
