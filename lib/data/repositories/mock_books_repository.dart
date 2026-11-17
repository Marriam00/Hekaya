import '../models.dart';
import 'books_repository.dart';

class MockBooksRepository extends BooksRepository {
  MockBooksRepository({
    required List<Book> books,
    required List<BookNote> notes,
    required BookVisibility defaultVisibility,
  }) {
    _books = List.of(books);
    _notes = List.of(notes);
    _defaultVisibility = defaultVisibility;
  }

  late final List<Book> _books;
  late final List<BookNote> _notes;
  late BookVisibility _defaultVisibility;

  @override
  List<Book> get books => List.unmodifiable(_books);

  @override
  List<BookNote> get notes => List.unmodifiable(_notes);

  @override
  BookVisibility get defaultVisibility => _defaultVisibility;

  @override
  Book? findBook(String id) {
    for (final book in _books) {
      if (book.id == id) return book;
    }
    return null;
  }

  @override
  List<BookNote> notesFor(String bookId) =>
      List.unmodifiable(_notes.where((note) => note.bookId == bookId));

  @override
  Future<void> saveBook(Book book, {required String privateNote}) async {
    final index = _books.indexWhere((saved) => saved.id == book.id);
    if (index == -1) {
      _books.add(book);
    } else {
      _books[index] = book;
    }

    final noteIndex = _notes.indexWhere((note) => note.bookId == book.id);
    final content = privateNote.trim();
    if (content.isEmpty) {
      if (noteIndex != -1) _notes.removeAt(noteIndex);
    } else if (noteIndex == -1) {
      _notes.add(
        BookNote(
          id: 'note-${book.id}',
          bookId: book.id,
          content: content,
        ),
      );
    } else {
      _notes[noteIndex] = BookNote(
        id: _notes[noteIndex].id,
        bookId: book.id,
        content: content,
      );
    }
    notifyListeners();
  }

  @override
  Future<void> setVisibility(String bookId, BookVisibility visibility) async {
    final index = _requireBookIndex(bookId);
    final current = _books[index];
    _books[index] = current.copyWith(
      visibility: visibility,
      allowLending: visibility == BookVisibility.private
          ? false
          : current.allowLending,
    );
    notifyListeners();
  }

  @override
  Future<void> setAllowLending(String bookId, bool allowed) async {
    final index = _requireBookIndex(bookId);
    final book = _books[index];
    _books[index] = book.copyWith(
      allowLending: book.visibility == BookVisibility.public && allowed,
    );
    notifyListeners();
  }

  @override
  Future<void> setPublicBookLending(String ownerId, bool allowed) async {
    var changed = false;
    for (var index = 0; index < _books.length; index++) {
      final book = _books[index];
      if (book.ownerId == ownerId && book.visibility == BookVisibility.public) {
        _books[index] = book.copyWith(allowLending: allowed);
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  @override
  Future<void> setDefaultVisibility(BookVisibility visibility) async {
    if (_defaultVisibility == visibility) return;
    _defaultVisibility = visibility;
    notifyListeners();
  }

  @override
  Future<void> deleteBook(String bookId) async {
    final before = _books.length;
    _books.removeWhere((book) => book.id == bookId);
    if (_books.length == before) throw StateError('Book $bookId does not exist.');
    _notes.removeWhere((note) => note.bookId == bookId);
    notifyListeners();
  }

  int _requireBookIndex(String id) {
    final index = _books.indexWhere((book) => book.id == id);
    if (index == -1) throw StateError('Book $id does not exist.');
    return index;
  }
}
