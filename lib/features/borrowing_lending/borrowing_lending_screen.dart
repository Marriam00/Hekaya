import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/models.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_header.dart';
import 'widgets/lending_sections.dart';

class BorrowingLendingScreen extends StatelessWidget {
  const BorrowingLendingScreen({super.key, required this.onOpenProfile});

  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    return DefaultTabController(
      length: 4,
      child: ListenableBuilder(
        listenable: repositories.changes,
        builder: (context, _) {
          final currentId = repositories.profiles.currentProfileId;
          final pending = repositories.lending.requests
              .where((request) => request.status == BorrowRequestStatus.pending)
              .toList();
          final incoming = pending
              .where((request) => request.ownerId == currentId)
              .toList();
          final sent = pending
              .where((request) => request.requesterId == currentId)
              .toList();
          final activeLoans = repositories.lending.loans
              .where((loan) => loan.status == LoanStatus.active)
              .toList();
          final borrowed = activeLoans
              .where((loan) => loan.borrowerId == currentId)
              .toList();
          final lentOut = activeLoans
              .where((loan) => loan.ownerId == currentId)
              .toList();
          final currentProfile = repositories.profiles.currentProfile;

          return Column(
            children: [
              AppHeader(
                sectionLabel: 'Borrowing & Lending',
                profileName: currentProfile.displayName,
                profileImageUrl: currentProfile.avatarUrl,
                onProfileTap: onOpenProfile,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.gutterCompact,
                  AppSpacing.pageMargin,
                  AppSpacing.spaceSm,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Borrowing & Lending',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
              TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Incoming (${incoming.length})'),
                  Tab(text: 'Sent (${sent.length})'),
                  Tab(text: 'Borrowed (${borrowed.length})'),
                  Tab(text: 'Lent Out (${lentOut.length})'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    LendingRequestList(
                      requests: incoming,
                      repositories: repositories,
                      incoming: true,
                    ),
                    LendingRequestList(
                      requests: sent,
                      repositories: repositories,
                      incoming: false,
                    ),
                    LendingLoanList(
                      loans: borrowed,
                      repositories: repositories,
                      borrowed: true,
                    ),
                    LendingLoanList(
                      loans: lentOut,
                      repositories: repositories,
                      borrowed: false,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
