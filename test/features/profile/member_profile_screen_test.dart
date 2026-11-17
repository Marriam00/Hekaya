import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/features/profile/member_profile_screen.dart';
import '../../helpers/test_app.dart';

void main() {
  testWidgets('member profile shows public books and latest post only', (
    tester,
  ) async {
    var openedPost = '';
    await tester.pumpWidget(
      repositoryTestApp(
        home: Scaffold(
          body: MemberProfileScreen(
            onOpenSettings: () {},
            onOpenBook: (_) {},
            onOpenPost: (id) => openedPost = id,
          ),
        ),
      ),
    );

    expect(find.text('Karim Mansour'), findsOneWidget);
    expect(find.text('Public Books (2)'), findsOneWidget);
    expect(find.text('Reading Now'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('7 comments'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('7 comments'));
    expect(openedPost, 'post-karim-invisible-cities');
    expect(tester.takeException(), isNull);
  });
}
