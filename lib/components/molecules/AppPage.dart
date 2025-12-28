import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AppPage({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
