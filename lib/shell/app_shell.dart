import 'package:flutter/material.dart';

import '../features/shared/widgets/app_bottom_navigation_bar.dart';
import '../core/theme/app_colors.dart';
import '../features/shared/placeholder_page.dart';
import '../features/home/home_screen.dart';

/// The main frame of the app: the page on top, the bottom bar below.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0; // 0 Home, 1 Discover, 2 Corner, 3 Profile

  // Replace these placeholders with the real screens in later phases.
  static const _pages = <Widget>[
    HomeScreen(),
    PlaceholderPage(title: 'Discover', subtitle: 'Discover goes here'),
    PlaceholderPage(
      title: 'Reading Corner',
      subtitle: 'Reading Corner goes here',
    ),
    PlaceholderPage(title: 'Profile', subtitle: 'Profile goes here'),
  ];

  void _openAddBook() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
          ),
          body: const PlaceholderPage(
            title: 'Add Book',
            subtitle: 'Add / Edit Book goes here',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _index,
        onSelected: (index) => setState(() => _index = index),
        onAdd: _openAddBook,
      ),
    );
  }
}
