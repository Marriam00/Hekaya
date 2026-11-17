import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/data/models.dart';
import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/features/profile_settings/profile_settings_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('settings update profile and book preferences', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 760);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repositories = HekayaRepositories.mock();
    await tester.pumpWidget(
      repositoryTestApp(
        repositories: repositories,
        home: Scaffold(
          body: ProfileSettingsScreen(
            onOpenLibrary: () {},
            onOpenBorrowing: () {},
          ),
        ),
      ),
    );

    expect(find.text('Sign Out'), findsNothing);
    expect(find.text('Invite a Reader'), findsNothing);
    await tester.tap(find.text('Private').first);
    await tester.pumpAndSettle();
    expect(repositories.books.defaultVisibility, BookVisibility.private);

    await tester.ensureVisible(find.text('Allow borrowing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow borrowing'));
    await tester.pumpAndSettle();
    expect(
      repositories.books.books
          .where(
            (book) =>
                book.ownerId == 'layla' &&
                book.visibility == BookVisibility.public,
          )
          .every((book) => !book.allowLending),
      isTrue,
    );

    await tester.ensureVisible(find.text('Edit Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Layla Reader');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repositories.profiles.currentProfile.displayName, 'Layla Reader');
    expect(tester.takeException(), isNull);
  });
}
