import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/hekaya_repositories.dart';
import 'data/repositories/repository_scope.dart';
import 'shell/app_shell.dart';

void main() {
  runApp(HekayaApp(repositories: HekayaRepositories.mock()));
}

class HekayaApp extends StatelessWidget {
  const HekayaApp({super.key, required this.repositories});

  final HekayaRepositories repositories;

  @override
  Widget build(BuildContext context) {
    return RepositoryScope(
      repositories: repositories,
      child: MaterialApp(
        title: 'Hekaya',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AppShell(),
      ),
    );
  }
}
