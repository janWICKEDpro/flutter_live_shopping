import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int maxQuantity;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.maxQuantity = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: AppColors.gray300),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '$quantity',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onPressed: quantity < maxQuantity
                ? () => onChanged(quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, VoidCallback? onPressed}) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      color: AppColors.gray800,
      disabledColor: AppColors.gray300,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      padding: EdgeInsets.zero,
    );
  }
}
