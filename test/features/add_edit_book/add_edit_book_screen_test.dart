import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/features/add_edit_book/add_edit_book_screen.dart';
import '../../helpers/test_app.dart';

void main() {
  testWidgets('saving a book writes the allowed fields through the repository', (
    tester,
  ) async {
    final repositories = HekayaRepositories.mock();
    var saved = false;
    await tester.pumpWidget(
      repositoryTestApp(
        repositories: repositories,
        home: Scaffold(
          body: AddEditBookScreen(onSaved: () => saved = true),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'New Volume');
    await tester.enterText(find.byType(TextFormField).at(1), 'A. Reader');
    await tester.scrollUntilVisible(
      find.text('Save Book'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save Book'));
    await tester.pumpAndSettle();

    expect(saved, isTrue);
    expect(
      repositories.books.books.any(
        (book) => book.title == 'New Volume' && book.author == 'A. Reader',
      ),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
