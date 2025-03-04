import 'package:calories_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends TextField {
  CustomTextField({
    super.key,
    required String label,
    bool obscureText = false,
    void Function(String value)? onChanged,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool? enabled,
    FocusNode? focusNode,
    Widget? suffixIcon,
  }) : super(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          cursorColor: Colors.white,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyles.white15Medium,
          focusNode: focusNode,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            label: Text(
              label,
              style: TextStyles.white15Medium,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        );
}
