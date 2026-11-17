import 'package:flutter/widgets.dart';

import 'hekaya_repositories.dart';

class RepositoryScope extends InheritedWidget {
  const RepositoryScope({
    super.key,
    required this.repositories,
    required super.child,
  });

  final HekayaRepositories repositories;

  static HekayaRepositories of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RepositoryScope>();
    assert(scope != null, 'RepositoryScope is missing above this context.');
    return scope!.repositories;
  }

  @override
  bool updateShouldNotify(RepositoryScope oldWidget) =>
      repositories != oldWidget.repositories;
}
