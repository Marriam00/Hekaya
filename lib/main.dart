import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'shell/app_shell.dart';

void main() {
  runApp(const HekayaApp());
}

class HekayaApp extends StatelessWidget {
  const HekayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hekaya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}
