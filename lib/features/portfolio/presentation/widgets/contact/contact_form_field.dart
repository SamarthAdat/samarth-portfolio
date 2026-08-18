import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// A styled text field used by the contact form.
class ContactFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const ContactFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: AppColors.accent,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.text, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.softMuted,
          fontSize: 15,
        ),
        filled: true,
        fillColor: AppColors.card,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 22,
          vertical: maxLines > 1 ? 22 : 20,
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.accent, width: 1.4),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error, width: 1.4),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
