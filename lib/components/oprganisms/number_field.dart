import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final bool allowDecimals;

  const NumberField({
    super.key,
    required this.controller,
    this.allowDecimals = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autocorrect: false,
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimals,
      ),
      inputFormatters: [
        allowDecimals
            ? FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}'))
            : FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text.replaceAll(',', '.');
          return newValue.copyWith(text: text);
        }),
      ],
    );
  }
}