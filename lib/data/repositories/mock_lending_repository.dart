import '../models.dart';
import 'lending_repository.dart';

class MockLendingRepository extends LendingRepository {
  MockLendingRepository({
    required List<BorrowRequest> requests,
    required List<Loan> loans,
  }) : _requests = List.of(requests),
       _loans = List.of(loans);

  final List<BorrowRequest> _requests;
  final List<Loan> _loans;

  @override
  List<BorrowRequest> get requests => List.unmodifiable(_requests);

  @override
  List<Loan> get loans => List.unmodifiable(_loans);

  @override
  Future<void> createRequest({
    required String bookId,
    required String requesterId,
    required String ownerId,
    required String message,
  }) async {
    if (requesterId == ownerId) {
      throw StateError('A book owner cannot request their own book.');
    }
    final hasPendingRequest = _requests.any(
      (request) =>
          request.bookId == bookId &&
          request.requesterId == requesterId &&
          request.status == BorrowRequestStatus.pending,
    );
    if (hasPendingRequest) {
      throw StateError('A pending request already exists for this book.');
    }

    _requests.add(
      BorrowRequest(
        id: 'request-${DateTime.now().microsecondsSinceEpoch}',
        bookId: bookId,
        requesterId: requesterId,
        ownerId: ownerId,
        message: message.trim(),
        status: BorrowRequestStatus.pending,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  @override
  Future<void> acceptRequest(String requestId) async {
    final index = _requirePendingRequest(requestId);
    final request = _requests[index];
    _requests[index] = request.copyWith(status: BorrowRequestStatus.accepted);
    final borrowedAt = DateTime.now();
    _loans.add(
      Loan(
        id: 'loan-${request.id}',
        bookId: request.bookId,
        borrowerId: request.requesterId,
        ownerId: request.ownerId,
        status: LoanStatus.active,
        borrowedAt: borrowedAt,
        expectedReturnAt: borrowedAt.add(const Duration(days: 21)),
        returnedAt: null,
      ),
    );
    notifyListeners();
  }

  @override
  Future<void> declineRequest(String requestId) async {
    final index = _requirePendingRequest(requestId);
    _requests[index] = _requests[index].copyWith(
      status: BorrowRequestStatus.rejected,
    );
    notifyListeners();
  }

  @override
  Future<void> cancelRequest(String requestId) async {
    final index = _requirePendingRequest(requestId);
    _requests[index] = _requests[index].copyWith(
      status: BorrowRequestStatus.cancelled,
    );
    notifyListeners();
  }

  @override
  Future<void> markReturned(String loanId) async {
    final index = _loans.indexWhere(
      (loan) => loan.id == loanId && loan.status == LoanStatus.active,
    );
    if (index == -1) throw StateError('Active loan $loanId does not exist.');
    _loans[index] = _loans[index].copyWith(
      status: LoanStatus.returned,
      returnedAt: DateTime.now(),
    );
    notifyListeners();
  }

  @override
  Future<void> removeBookReferences(String bookId) async {
    if (_loans.any(
      (loan) => loan.bookId == bookId && loan.status == LoanStatus.active,
    )) {
      throw StateError('A book cannot be deleted while it is on loan.');
    }
    _requests.removeWhere((request) => request.bookId == bookId);
    _loans.removeWhere((loan) => loan.bookId == bookId);
    notifyListeners();
  }

  int _requirePendingRequest(String id) {
    final index = _requests.indexWhere(
      (request) =>
          request.id == id && request.status == BorrowRequestStatus.pending,
    );
    if (index == -1) throw StateError('Pending request $id does not exist.');
    return index;
  }
}
