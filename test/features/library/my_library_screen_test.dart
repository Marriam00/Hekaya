import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/data/models.dart';
import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/features/library/my_library_screen.dart';
import '../../helpers/test_app.dart';

void main() {
  testWidgets('library filters and visibility menu update repository data', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 760);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repositories = HekayaRepositories.mock();
    await tester.pumpWidget(
      repositoryTestApp(
        repositories: repositories,
        home: Scaffold(
          body: MyLibraryScreen(
            onAddBook: () {},
            onOpenBook: (_) {},
            onEditBook: (_) {},
            onOpenProfile: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('The Shadow of the Wind'), findsOneWidget);

    await tester.tap(find.byTooltip('Book actions').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Make Private'));
    await tester.pumpAndSettle();

    expect(
      repositories.books.findBook('shadow-of-the-wind')?.visibility,
      BookVisibility.private,
    );
    expect(tester.takeException(), isNull);
  });
}
