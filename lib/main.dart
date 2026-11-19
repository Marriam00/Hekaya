import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/hekaya_repositories.dart';
import 'data/repositories/repository_scope.dart';
import 'features/auth/app_not_configured_screen.dart';
import 'features/auth/auth_gate.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/auth_repository_scope.dart';
import 'features/auth/supabase_auth_repository.dart';
import 'shell/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  if (supabaseUrl.trim().isEmpty || supabaseAnonKey.trim().isEmpty) {
    runApp(const _HekayaNotConfiguredApp());
    return;
  }

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
    debug: false,
  );
  runApp(
    HekayaApp(
      repositories: HekayaRepositories.mock(),
      authRepository: SupabaseAuthRepository(Supabase.instance.client),
    ),
  );
}

class HekayaApp extends StatelessWidget {
  const HekayaApp({
    super.key,
    required this.repositories,
    required this.authRepository,
  });

  final HekayaRepositories repositories;
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryScope(
      repositories: repositories,
      child: AuthRepositoryScope(
        repository: authRepository,
        child: MaterialApp(
          title: 'Hekaya',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const AppShell(),
          builder: (context, app) =>
              AuthGate(app: app ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}

class _HekayaNotConfiguredApp extends StatelessWidget {
  const _HekayaNotConfiguredApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hekaya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppNotConfiguredScreen(),
    );
  }
}
