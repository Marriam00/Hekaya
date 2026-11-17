import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/features/reading_corner/reading_corner_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('publishing a thought updates the feed and question filter', (
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
          body: ReadingCornerScreen(
            onOpenThread: (_) {},
            onOpenBook: (_) {},
            onOpenProfile: () {},
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.byType(TextField).first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.byType(TextField).first,
      'A new reading thought',
    );
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Publish Thought'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final publishButton = find.ancestor(
      of: find.text('Publish Thought'),
      matching: find.byType(FilledButton),
    );
    expect(tester.widget<FilledButton>(publishButton).onPressed, isNotNull);
    await tester.tap(find.text('Publish Thought'));
    await tester.pumpAndSettle();
    expect(
      repositories.posts.posts.any(
        (post) => post.content == 'A new reading thought',
      ),
      isTrue,
    );

    await tester.ensureVisible(find.text('Questions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Questions'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Which Borges translation do you find most faithful to his philosophical cadence?',
      ),
      findsOneWidget,
    );
    expect(find.text('A new reading thought'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
