import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/data/models.dart';
import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/features/book_details/book_details_screen.dart';
import '../../helpers/test_app.dart';

void main() {
  testWidgets('member can request an available book from details', (
    tester,
  ) async {
    final repositories = HekayaRepositories.mock();
    await tester.pumpWidget(
      repositoryTestApp(
        repositories: repositories,
        home: Scaffold(
          body: BookDetailsScreen(
            bookId: 'orlando',
            onBack: () {},
            onEditBook: (_) {},
            onOpenProfile: () {},
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Request to Borrow'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Request to Borrow'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(
      repositories.lending.requests.any(
        (request) =>
            request.bookId == 'orlando' &&
            request.requesterId == 'layla' &&
            request.status == BorrowRequestStatus.pending,
      ),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
