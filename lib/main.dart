import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: NiezapominapkaApp()));
}

class NiezapominapkaApp extends StatelessWidget {
  const NiezapominapkaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niezapominapka',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
