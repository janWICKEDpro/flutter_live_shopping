import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';

class ShippingForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController zipController;

  const ShippingForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.streetController,
    required this.cityController,
    required this.zipController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your email' : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: streetController,
            label: 'Street Address',
            icon: Icons.home_outlined,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your address' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: cityController,
                  label: 'City',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: zipController,
                  label: 'ZIP Code',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.gray50,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
