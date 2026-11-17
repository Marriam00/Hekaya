import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/data/repositories/hekaya_repositories.dart';
import 'package:hekaya/features/post_details/post_details_screen.dart';
import '../../helpers/test_app.dart';

void main() {
  testWidgets('sending a comment adds a flat comment to the post', (
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
          body: PostDetailsScreen(
            postId: 'post-karim-invisible-cities',
            onBack: () {},
            onOpenProfile: () {},
            onOpenBook: (_) {},
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.byType(TextField),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(find.byType(TextField), 'A new comment');
    await tester.pump();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(
      repositories.posts.commentsFor('post-karim-invisible-cities').any(
        (comment) =>
            comment.content == 'A new comment' && comment.authorId == 'layla',
      ),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
