import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/features/home/home_screen.dart';
import '../../helpers/test_app.dart';

void main() {
  testWidgets('home stays usable on a narrow phone and routes shortcuts', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 760);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var libraryOpened = false;
    var discoverOpened = false;
    await tester.pumpWidget(
      repositoryTestApp(
        home: Scaffold(
          body: HomeScreen(
            onViewLibrary: () => libraryOpened = true,
            onBookDetails: (_) {},
            onBorrowingLending: () {},
            onPostDetails: (_) {},
            onDiscover: () => discoverOpened = true,
            onOpenProfile: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Good evening,'), findsOneWidget);
    expect(find.text('Archived Today'), findsNothing);
    expect(find.byTooltip('Notifications'), findsNothing);

    await tester.tap(find.byType(TextField).first);
    expect(libraryOpened, isTrue);
    await tester.ensureVisible(find.text('Discover Circle Books'));
    await tester.tap(find.text('Discover Circle Books'));
    expect(discoverOpened, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home navigation opens the library tab', (tester) async {
    await tester.pumpWidget(repositoryTestApp());
    await tester.tap(find.text('View Library'));
    await tester.pumpAndSettle();
    expect(find.text('My Library'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
