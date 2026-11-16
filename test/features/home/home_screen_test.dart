import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hekaya/core/theme/app_theme.dart';
import 'package:hekaya/features/home/home_screen.dart';
import 'package:hekaya/features/shared/widgets/app_bottom_navigation_bar.dart';

void main() {
  testWidgets('home dashboard lays out on a narrow phone', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 760);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: const HomeScreen(),
          bottomNavigationBar: AppBottomNavigationBar(
            selectedIndex: 0,
            onSelected: (_) {},
            onAdd: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Good evening,'), findsOneWidget);
    expect(find.text('Circulation & Lending'), findsOneWidget);
    expect(find.text('Discover Circle Books'), findsOneWidget);
  });
}
