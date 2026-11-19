import 'package:flutter/widgets.dart';

import 'auth_repository.dart';

class AuthRepositoryScope extends InheritedWidget {
  const AuthRepositoryScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final AuthRepository repository;

  static AuthRepository of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AuthRepositoryScope>();
    assert(
      scope != null,
      'AuthRepositoryScope is missing from the widget tree.',
    );
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(AuthRepositoryScope oldWidget) =>
      repository != oldWidget.repository;
}
