import 'package:flutter/material.dart';
import 'package:root_app/constants/const_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String labelText;
  final String hintText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool? readOnly;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onSaved;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final Widget? suffix;
  final List<String>? autofillHints; // Added autofillHints parameter

  const AppTextField({
    super.key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.labelText,
    required this.hintText,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.readOnly = false,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.maxLines = 1,
    this.suffix,
    this.autofillHints, // Accept autofillHints parameter
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        style: const TextStyle(color: kTextColor),
        controller: controller,
        maxLines: maxLines!,
        onChanged: onChanged,
        onSaved: onSaved,
        readOnly: readOnly!,
        obscureText: obscureText!,
        keyboardType: keyboardType,
        autofillHints: autofillHints, // Pass autofillHints to TextFormField
        decoration: InputDecoration(
          hintText: hintText,
          floatingLabelBehavior: floatingLabelBehavior,
          suffixIcon: suffix,
          labelText: labelText,
          errorStyle: const TextStyle(fontSize: 1.0),
        ),
        validator: validator,
      ),
    );
  }
}
