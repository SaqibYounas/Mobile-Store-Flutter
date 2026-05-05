import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// White-filled rounded text field with a leading icon. Used inside the
/// payment screen for delivery + card details.
class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        maxLines: isPassword ? 1 : maxLines,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator:
            validator ?? (v) => (v == null || v.isEmpty) ? 'Required field' : null,
      ),
    );
  }
}
