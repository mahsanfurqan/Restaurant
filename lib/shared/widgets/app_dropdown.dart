import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? Function(T?)? validator;
  final String? errorText;
  final InputDecoration? decoration;
  final bool enabled;

  const AppDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.validator,
    this.errorText,
    this.decoration,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
      isExpanded: true,
    );
  }
}
