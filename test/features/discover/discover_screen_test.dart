import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/data/models.dart';
import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/features/discover/discover_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('Request opens the optional-note dialog and creates a request', (
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
        home: Scaffold(body: DiscoverScreen(onOpenProfile: () {})),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Request').first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Request').first);
    await tester.pumpAndSettle();
    expect(find.text('Request “Orlando”'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField).last,
      'I would like to read this next.',
    );
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(
      repositories.lending.requests.any(
        (request) =>
            request.requesterId == 'layla' &&
            request.message == 'I would like to read this next.' &&
            request.status == BorrowRequestStatus.pending,
      ),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
