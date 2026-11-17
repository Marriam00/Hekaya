import 'package:flutter/material.dart';

import 'package:hekaya/core/theme/app_theme.dart';
import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/data/repositories/repository_scope.dart';
import 'package:hekaya/shell/app_shell.dart';

Widget repositoryTestApp({
  Widget? home,
  HekayaRepositories? repositories,
}) {
  return RepositoryScope(
    repositories: repositories ?? HekayaRepositories.mock(),
    child: MaterialApp(
      theme: AppTheme.light,
      home: home ?? const AppShell(),
    ),
  );
}
