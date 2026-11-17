import 'models.dart';

T? firstOrNull<T>(Iterable<T> values) {
  final iterator = values.iterator;
  return iterator.moveNext() ? iterator.current : null;
}

bool hasActiveLoan(String bookId, Iterable<Loan> loans) => loans.any(
  (loan) => loan.bookId == bookId && loan.status == LoanStatus.active,
);

bool isBookAvailable(Book book, Iterable<Loan> loans) =>
    book.visibility == BookVisibility.public &&
    book.allowLending &&
    !hasActiveLoan(book.id, loans);

int daysUntil(DateTime date, {DateTime? now}) {
  final difference = date.difference(now ?? DateTime.now());
  if (difference <= Duration.zero) return 0;
  const millisecondsPerDay = 24 * 60 * 60 * 1000;
  return (difference.inMilliseconds / millisecondsPerDay).ceil();
}

String relativeTime(DateTime date, {DateTime? now}) {
  final difference = (now ?? DateTime.now()).difference(date);
  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inHours < 1) return '${difference.inMinutes}m ago';
  if (difference.inDays < 1) return '${difference.inHours}h ago';
  if (difference.inDays < 7) return '${difference.inDays}d ago';
  return '${date.day}/${date.month}/${date.year}';
}

String shortDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
