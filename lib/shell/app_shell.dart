import 'package:flutter/material.dart';

import '../features/add_edit_book/add_edit_book_screen.dart';
import '../features/book_details/book_details_screen.dart';
import '../features/borrowing_lending/borrowing_lending_screen.dart';
import '../features/discover/discover_screen.dart';
import '../features/home/home_screen.dart';
import '../features/library/my_library_screen.dart';
import '../features/post_details/post_details_screen.dart';
import '../features/profile/member_profile_screen.dart';
import '../features/profile_settings/profile_settings_screen.dart';
import '../features/reading_corner/reading_corner_screen.dart';
import '../features/shared/widgets/app_bottom_navigation_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  late final _pages = <Widget>[
    HomeScreen(
      onViewLibrary: _openLibrary,
      onBookDetails: _openBookDetails,
      onBorrowingLending: _openBorrowingLending,
      onPostDetails: _openPostDetails,
      onDiscover: () => setState(() => _index = 1),
      onOpenProfile: _openProfileSettings,
    ),
    DiscoverScreen(onOpenProfile: _openProfileSettings),
    ReadingCornerScreen(
      onOpenThread: _openPostDetails,
      onOpenBook: _openBookDetails,
      onOpenProfile: _openProfileSettings,
    ),
    MemberProfileScreen(
      onOpenSettings: _openProfileSettings,
      onOpenBook: _openBookDetails,
      onOpenPost: _openPostDetails,
    ),
  ];

  void _openAddBook({String? bookId}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          body: AddEditBookScreen(
            bookId: bookId,
            onSaved: () => Navigator.of(routeContext).pop(),
          ),
          bottomNavigationBar: _routeNavigation(routeContext),
        ),
      ),
    );
  }

  void _openBookDetails(String bookId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          body: BookDetailsScreen(
            bookId: bookId,
            onBack: () => Navigator.of(routeContext).pop(),
            onEditBook: (id) => _openAddBook(bookId: id),
            onOpenProfile: _openProfileSettings,
          ),
          bottomNavigationBar: _routeNavigation(routeContext),
        ),
      ),
    );
  }

  void _openBorrowingLending() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          body: BorrowingLendingScreen(onOpenProfile: _openProfileSettings),
          bottomNavigationBar: _routeNavigation(routeContext),
        ),
      ),
    );
  }

  void _openProfileSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          body: ProfileSettingsScreen(
            onOpenLibrary: _openLibrary,
            onOpenBorrowing: _openBorrowingLending,
          ),
          bottomNavigationBar: _routeNavigation(routeContext),
        ),
      ),
    );
  }

  void _openPostDetails(String postId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          body: PostDetailsScreen(
            postId: postId,
            onBack: () => Navigator.of(routeContext).pop(),
            onOpenProfile: _openProfileSettings,
            onOpenBook: _openBookDetails,
          ),
          bottomNavigationBar: _routeNavigation(routeContext),
        ),
      ),
    );
  }

  void _openLibrary() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeContext) => Scaffold(
          body: MyLibraryScreen(
            onAddBook: () => _openAddBook(),
            onOpenBook: _openBookDetails,
            onEditBook: (id) => _openAddBook(bookId: id),
            onOpenProfile: _openProfileSettings,
          ),
          bottomNavigationBar: _routeNavigation(routeContext),
        ),
      ),
    );
  }

  Widget _routeNavigation(BuildContext routeContext) {
    return AppBottomNavigationBar(
      selectedIndex: _index,
      onSelected: (index) {
        Navigator.of(routeContext).popUntil((route) => route.isFirst);
        setState(() => _index = index);
      },
      onAdd: () {
        Navigator.of(routeContext).popUntil((route) => route.isFirst);
        _openAddBook();
      },
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
