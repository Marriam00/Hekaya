import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/derived_values.dart';
import '../../data/models.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_header.dart';
import '../shared/widgets/app_search_field.dart';
import 'widgets/home_discover_banner.dart';
import 'widgets/home_greeting_section.dart';
import 'widgets/home_latest_post_card.dart';
import 'widgets/home_lending_summary_card.dart';
import 'widgets/home_library_summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onViewLibrary,
    required this.onBookDetails,
    required this.onBorrowingLending,
    required this.onPostDetails,
    required this.onDiscover,
    required this.onOpenProfile,
  });

  final VoidCallback onViewLibrary;
  final ValueChanged<String> onBookDetails;
  final VoidCallback onBorrowingLending;
  final ValueChanged<String> onPostDetails;
  final VoidCallback onDiscover;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    return ListenableBuilder(
      listenable: repositories.changes,
      builder: (context, _) {
        final currentProfile = repositories.profiles.currentProfile;
        final ownedBooks = repositories.books.books
            .where((book) => book.ownerId == currentProfile.id)
            .toList();
        final currentBook = firstOrNull(
          ownedBooks.where((book) => book.readingStatus == ReadingStatus.reading),
        );
        final incomingRequests = repositories.lending.requests
            .where(
              (request) =>
                  request.ownerId == currentProfile.id &&
                  request.status == BorrowRequestStatus.pending,
            )
            .toList();
        final lentLoans = repositories.lending.loans
            .where(
              (loan) =>
                  loan.ownerId == currentProfile.id &&
                  loan.status == LoanStatus.active,
            )
            .toList();
        final request = firstOrNull(incomingRequests);
        final requestBook = request == null
            ? null
            : repositories.books.findBook(request.bookId);
        final requester = request == null
            ? null
            : repositories.profiles.findProfile(request.requesterId);
        final activeLoan = firstOrNull(lentLoans);
        final loanBook = activeLoan == null
            ? null
            : repositories.books.findBook(activeLoan.bookId);
        final borrower = activeLoan == null
            ? null
            : repositories.profiles.findProfile(activeLoan.borrowerId);
        final latestPosts = [...repositories.posts.posts]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final latestPost = firstOrNull(latestPosts);
        final postAuthor = latestPost == null
            ? null
            : repositories.profiles.findProfile(latestPost.authorId);
        final postBook = latestPost?.bookId == null
            ? null
            : repositories.books.findBook(latestPost!.bookId!);
        final sharedBookCount = repositories.books.books
            .where(
              (book) =>
                  book.visibility == BookVisibility.public &&
                  book.ownerId != currentProfile.id,
            )
            .length;

        return Column(
          children: [
            AppHeader(
              sectionLabel: 'Home',
              profileName: currentProfile.displayName,
              profileImageUrl: currentProfile.avatarUrl,
              onProfileTap: onOpenProfile,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.spaceSm,
                  AppSpacing.pageMargin,
                  AppSpacing.spaceXl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeGreetingSection(
                      profile: currentProfile,
                      currentBook: currentBook,
                      onCurrentBookTap: currentBook == null
                          ? null
                          : () => onBookDetails(currentBook.id),
                    ),
                    const SizedBox(height: AppSpacing.gutterCompact),
                    AppSearchField(
                      hintText: 'Search your books, friends, or discussions...',
                      readOnly: true,
                      onTap: onViewLibrary,
                    ),
                    const SizedBox(height: AppSpacing.gutter),
                    HomeLibrarySummaryCard(
                      books: ownedBooks,
                      onViewLibrary: onViewLibrary,
                    ),
                    const SizedBox(height: AppSpacing.gutter),
                    HomeLendingSummaryCard(
                      request: request,
                      requestedBook: requestBook,
                      requester: requester,
                      activeLoan: activeLoan,
                      loanBook: loanBook,
                      borrower: borrower,
                      activeCount: incomingRequests.length + lentLoans.length,
                      onAccept: request == null
                          ? onBorrowingLending
                          : () => repositories.lending.acceptRequest(request.id),
                      onDecline: request == null
                          ? onBorrowingLending
                          : () =>
                                repositories.lending.declineRequest(request.id),
                      onViewLoans: onBorrowingLending,
                    ),
                    const SizedBox(height: AppSpacing.gutter),
                    HomeLatestPostCard(
                      post: latestPost,
                      author: postAuthor,
                      book: postBook,
                      commentCount: latestPost == null
                          ? 0
                          : repositories.posts
                                .commentsFor(latestPost.id)
                                .length,
                      onOpenPost: latestPost == null
                          ? null
                          : () => onPostDetails(latestPost.id),
                    ),
                    const SizedBox(height: AppSpacing.gutter),
                    HomeDiscoverBanner(
                      titleCount: sharedBookCount,
                      onTap: onDiscover,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
