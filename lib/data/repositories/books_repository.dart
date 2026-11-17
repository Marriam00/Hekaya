import 'package:flutter/foundation.dart';

import '../models.dart';

abstract class BooksRepository extends ChangeNotifier {
  List<Book> get books;
  List<BookNote> get notes;
  Book? findBook(String id);
  List<BookNote> notesFor(String bookId);
  BookVisibility get defaultVisibility;

  Future<void> saveBook(Book book, {required String privateNote});
  Future<void> setVisibility(String bookId, BookVisibility visibility);
  Future<void> setAllowLending(String bookId, bool allowed);
  Future<void> setPublicBookLending(String ownerId, bool allowed);
  Future<void> setDefaultVisibility(BookVisibility visibility);
  Future<void> deleteBook(String bookId);
}
