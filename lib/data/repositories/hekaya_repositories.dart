import 'package:flutter/foundation.dart';

import 'mock_books_repository.dart';
import 'mock_hekaya_seed.dart';
import 'mock_lending_repository.dart';
import 'mock_posts_repository.dart';
import 'mock_profile_repository.dart';
import 'books_repository.dart';
import 'lending_repository.dart';
import 'posts_repository.dart';
import 'profile_repository.dart';

class HekayaRepositories {
  HekayaRepositories({
    required this.books,
    required this.lending,
    required this.posts,
    required this.profiles,
  }) : changes = Listenable.merge([books, lending, posts, profiles]);

  final BooksRepository books;
  final LendingRepository lending;
  final PostsRepository posts;
  final ProfileRepository profiles;
  final Listenable changes;

  Future<void> deleteBook(String bookId) async {
    if (books.findBook(bookId) == null) {
      throw StateError('Book $bookId does not exist.');
    }
    await lending.removeBookReferences(bookId);
    await books.deleteBook(bookId);
  }

  factory HekayaRepositories.mock() {
    final seed = MockHekayaSeed.create();
    return HekayaRepositories(
      books: MockBooksRepository(
        books: seed.books,
        notes: seed.bookNotes,
        defaultVisibility: seed.defaultVisibility,
      ),
      lending: MockLendingRepository(
        requests: seed.requests,
        loans: seed.loans,
      ),
      posts: MockPostsRepository(posts: seed.posts, comments: seed.comments),
      profiles: MockProfileRepository(
        profiles: seed.profiles,
        currentProfileId: seed.currentProfileId,
      ),
    );
  }
}
