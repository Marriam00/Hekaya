import 'package:flutter/material.dart';
import 'package:hekaya/core/theme/app_theme.dart';
import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/data/repositories/repository_scope.dart';
import 'package:hekaya/features/auth/auth_gate.dart';
import 'package:hekaya/features/auth/auth_repository.dart';
import 'package:hekaya/features/auth/auth_repository_scope.dart';
import 'package:hekaya/shell/app_shell.dart';

Widget authTestApp({
  required AuthRepository authRepository,
  HekayaRepositories? repositories,
}) {
  return RepositoryScope(
    repositories: repositories ?? HekayaRepositories.mock(),
    child: AuthRepositoryScope(
      repository: authRepository,
      child: MaterialApp(
        theme: AppTheme.light,
        home: const AppShell(),
        builder: (context, app) =>
            AuthGate(app: app ?? const SizedBox.shrink()),
      ),
    ),
  );
}
