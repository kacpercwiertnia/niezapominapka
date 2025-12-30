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
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimals,
      ),
      inputFormatters: [
        // 1. Blokada znaków nieliczbowych
        allowDecimals
            ? FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}'))
            : FilteringTextInputFormatter.digitsOnly,

        // 2. Konwersja przecinka na kropkę
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text.replaceAll(',', '.');
          return newValue.copyWith(text: text);
        }),
      ],
      decoration: InputDecoration(
        // Brak labelText sprawia, że pole jest czyste
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}