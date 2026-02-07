import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';

enum PaymentMethod { card, paypal, applePay }

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildOption(
          context,
          PaymentMethod.card,
          'Credit Card',
          Icons.credit_card,
        ),
        const SizedBox(height: 8),
        _buildOption(
          context,
          PaymentMethod.paypal,
          'PayPal',
          Icons.account_balance_wallet,
        ),
        const SizedBox(height: 8),
        _buildOption(
          context,
          PaymentMethod.applePay,
          'Apple Pay',
          Icons.phone_iphone,
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    PaymentMethod method,
    String label,
    IconData icon,
  ) {
    final isSelected = selectedMethod == method;
    return InkWell(
      onTap: () => onChanged(method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.gray600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.gray800,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary)
            else
              const Icon(Icons.circle_outlined, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}
