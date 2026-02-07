import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';

class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray200,
      highlightColor: AppColors.gray100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.gray200,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(
            height: 160,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader(width: 200, height: 16),
                const SizedBox(height: 8),
                const SkeletonLoader(width: 150, height: 14),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SkeletonLoader(width: 80, height: 24),
                    const Spacer(),
                    SkeletonLoader(
                      width: 24,
                      height: 24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SkeletonLoader(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 100, height: 12),
                SizedBox(height: 4),
                SkeletonLoader(width: 60, height: 12),
                SizedBox(height: 8),
                SkeletonLoader(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
