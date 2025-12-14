import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/groups/GroupsScreen.dart';

import 'theme.dart';

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
      home: const GroupsScreen(),
    );
  }
}
