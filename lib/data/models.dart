enum BookVisibility { public, private }

enum ReadingStatus { toRead, reading, finished }

enum BorrowRequestStatus { pending, accepted, rejected, cancelled }

enum LoanStatus { active, returned }

enum PostType { thought, question }

class Profile {
  const Profile({
    required this.id,
    required this.displayName,
    required this.bio,
    required this.avatarUrl,
    required this.createdAt,
  });

  final String id;
  final String displayName;
  final String bio;
  final String avatarUrl;
  final DateTime createdAt;

  Profile copyWith({String? displayName, String? bio, String? avatarUrl}) {
    return Profile(
      id: id,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }
}

class Book {
  const Book({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.genre,
    required this.visibility,
    required this.allowLending,
    required this.readingStatus,
    required this.createdAt,
  });

  final String id;
  final String ownerId;
  final String title;
  final String author;
  final String coverUrl;
  final String description;
  final String genre;
  final BookVisibility visibility;
  final bool allowLending;
  final ReadingStatus readingStatus;
  final DateTime createdAt;

  Book copyWith({
    String? title,
    String? author,
    String? coverUrl,
    String? description,
    String? genre,
    BookVisibility? visibility,
    bool? allowLending,
    ReadingStatus? readingStatus,
  }) {
    return Book(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      visibility: visibility ?? this.visibility,
      allowLending: allowLending ?? this.allowLending,
      readingStatus: readingStatus ?? this.readingStatus,
      createdAt: createdAt,
    );
  }
}

class BookNote {
  const BookNote({
    required this.id,
    required this.bookId,
    required this.content,
  });

  final String id;
  final String bookId;
  final String content;
}

class BorrowRequest {
  const BorrowRequest({
    required this.id,
    required this.bookId,
    required this.requesterId,
    required this.ownerId,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String bookId;
  final String requesterId;
  final String ownerId;
  final String message;
  final BorrowRequestStatus status;
  final DateTime createdAt;

  BorrowRequest copyWith({BorrowRequestStatus? status}) {
    return BorrowRequest(
      id: id,
      bookId: bookId,
      requesterId: requesterId,
      ownerId: ownerId,
      message: message,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

class Loan {
  const Loan({
    required this.id,
    required this.bookId,
    required this.borrowerId,
    required this.ownerId,
    required this.status,
    required this.borrowedAt,
    required this.expectedReturnAt,
    required this.returnedAt,
  });

  final String id;
  final String bookId;
  final String borrowerId;
  final String ownerId;
  final LoanStatus status;
  final DateTime borrowedAt;
  final DateTime expectedReturnAt;
  final DateTime? returnedAt;

  Loan copyWith({LoanStatus? status, DateTime? returnedAt}) {
    return Loan(
      id: id,
      bookId: bookId,
      borrowerId: borrowerId,
      ownerId: ownerId,
      status: status ?? this.status,
      borrowedAt: borrowedAt,
      expectedReturnAt: expectedReturnAt,
      returnedAt: returnedAt ?? this.returnedAt,
    );
  }
}

class Post {
  const Post({
    required this.id,
    required this.authorId,
    required this.bookId,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String authorId;
  final String? bookId;
  final String content;
  final PostType type;
  final DateTime createdAt;
}

class Comment {
  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
}
