import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/data/models.dart';
import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/features/borrowing_lending/borrowing_lending_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('incoming, sent, borrowed and lent actions change repository', (
    tester,
  ) async {
    final repositories = HekayaRepositories.mock();
    await tester.pumpWidget(
      repositoryTestApp(
        repositories: repositories,
        home: Scaffold(body: BorrowingLendingScreen(onOpenProfile: () {})),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();
    expect(
      repositories.lending.requests
          .firstWhere((request) => request.id == 'request-omar-kafka')
          .status,
      BorrowRequestStatus.accepted,
    );
    expect(
      repositories.lending.loans.any(
        (loan) => loan.bookId == 'kafka-on-the-shore',
      ),
      isTrue,
    );
    final acceptedLoan = repositories.lending.loans.firstWhere(
      (loan) => loan.bookId == 'kafka-on-the-shore',
    );
    expect(
      acceptedLoan.expectedReturnAt.difference(acceptedLoan.borrowedAt),
      const Duration(days: 21),
    );

    await tester.tap(find.textContaining('Sent'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel Request'));
    await tester.pumpAndSettle();
    expect(
      repositories.lending.requests
          .firstWhere((request) => request.id == 'request-layla-master')
          .status,
      BorrowRequestStatus.cancelled,
    );

    await tester.tap(find.textContaining('Borrowed'));
    await tester.pumpAndSettle();
    expect(find.text('Mark as Returned'), findsNothing);

    await tester.tap(find.textContaining('Lent Out'));
    await tester.pumpAndSettle();
    expect(find.text('Mark as Returned'), findsNWidgets(2));
    expect(find.text('Due in 21 days'), findsOneWidget);
    await tester.tap(find.text('Mark as Returned').first);
    await tester.pumpAndSettle();
    expect(
      repositories.lending.loans
          .firstWhere((loan) => loan.id == 'loan-ficciones')
          .status,
      LoanStatus.returned,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Decline marks an incoming request as rejected', (tester) async {
    final repositories = HekayaRepositories.mock();
    await tester.pumpWidget(
      repositoryTestApp(
        repositories: repositories,
        home: Scaffold(body: BorrowingLendingScreen(onOpenProfile: () {})),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Decline'));
    await tester.pumpAndSettle();

    expect(
      repositories.lending.requests
          .firstWhere((request) => request.id == 'request-omar-kafka')
          .status,
      BorrowRequestStatus.rejected,
    );
    expect(tester.takeException(), isNull);
  });
}
