import 'package:flutter/foundation.dart';

import '../models.dart';

abstract class LendingRepository extends ChangeNotifier {
  List<BorrowRequest> get requests;
  List<Loan> get loans;

  Future<void> createRequest({
    required String bookId,
    required String requesterId,
    required String ownerId,
    required String message,
  });
  Future<void> acceptRequest(String requestId);
  Future<void> declineRequest(String requestId);
  Future<void> cancelRequest(String requestId);
  Future<void> markReturned(String loanId);
  Future<void> removeBookReferences(String bookId);
}
