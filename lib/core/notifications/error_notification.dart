import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating, // Sprawia, że pasek "pływa" nad dołem
      margin: const EdgeInsets.all(16),    // Odstępy od krawędzi ekranu
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}