import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/derived_values.dart';
import '../../data/models.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/borrow_request_dialog.dart';
import '../shared/widgets/app_filter_chip.dart';
import '../shared/widgets/app_header.dart';
import '../shared/widgets/app_search_field.dart';
import 'widgets/discover_book_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key, required this.onOpenProfile});

  final VoidCallback onOpenProfile;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _genre = 'All genres';
  bool _availableOnly = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    return ListenableBuilder(
      listenable: repositories.changes,
      builder: (context, _) {
        final currentProfile = repositories.profiles.currentProfile;
        final sharedBooks = repositories.books.books
            .where(
              (book) =>
                  book.visibility == BookVisibility.public &&
                  book.ownerId != currentProfile.id,
            )
            .toList();
        final genres = <String>{
          'All genres',
          ...sharedBooks.map((book) => book.genre),
        }.toList();
        final normalizedQuery = _query.trim().toLowerCase();
        final visibleBooks = sharedBooks.where((book) {
          final owner = repositories.profiles.findProfile(book.ownerId);
          final available = isBookAvailable(book, repositories.lending.loans);
          return (!_availableOnly || available) &&
              (_genre == 'All genres' || book.genre == _genre) &&
              (normalizedQuery.isEmpty ||
                  '${book.title} ${book.author} ${owner?.displayName ?? ''}'
                      .toLowerCase()
                      .contains(normalizedQuery));
        }).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return Column(
          children: [
            AppHeader(
              sectionLabel: 'Discover',
              profileName: currentProfile.displayName,
              profileImageUrl: currentProfile.avatarUrl,
              onProfileTap: widget.onOpenProfile,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.spaceSm,
                  AppSpacing.pageMargin,
                  AppSpacing.spaceXl,
                ),
                children: [
                  Text(
                    'Discover',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.spaceXs),
                  Text(
                    'Books shared by your circle',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  AppSearchField(
                    controller: _searchController,
                    hintText: 'Search title, author, or owner...',
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: AppSpacing.gutterCompact),
                  _AvailabilityToggle(
                    availableOnly: _availableOnly,
                    onChanged: (value) =>
                        setState(() => _availableOnly = value),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final genre in genres) ...[
                          if (genre != genres.first)
                            const SizedBox(width: AppSpacing.spaceSm),
                          AppFilterChip(
                            label: genre,
                            selected: _genre == genre,
                            paddedTapTarget: true,
                            onSelected: (_) => setState(() => _genre = genre),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  if (visibleBooks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.spaceXl,
                      ),
                      child: Text(
                        'No shared books match your search.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    for (final book in visibleBooks) ...[
                      DiscoverBookCard(
                        book: book,
                        owner: repositories.profiles.findProfile(book.ownerId),
                        available: isBookAvailable(
                          book,
                          repositories.lending.loans,
                        ),
                        requestPending: repositories.lending.requests.any(
                          (request) =>
                              request.bookId == book.id &&
                              request.requesterId == currentProfile.id &&
                              request.status == BorrowRequestStatus.pending,
                        ),
                        onRequest: () => _requestBook(book),
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                    ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestBook(Book book) async {
    final repositories = RepositoryScope.of(context);
    final owner = repositories.profiles.findProfile(book.ownerId);
    if (owner == null) throw StateError('Book owner does not exist.');
    final note = await showBorrowRequestDialog(context, book: book, owner: owner);
    if (note == null) return;
    await repositories.lending.createRequest(
      bookId: book.id,
      requesterId: repositories.profiles.currentProfileId,
      ownerId: owner.id,
      message: note,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent.')),
      );
    }
  }
}

class _AvailabilityToggle extends StatelessWidget {
  const _AvailabilityToggle({
    required this.availableOnly,
    required this.onChanged,
  });

  final bool availableOnly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceXs),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppFilterChip(
              label: 'Available now',
              selected: availableOnly,
              paddedTapTarget: true,
              onSelected: (_) => onChanged(true),
            ),
          ),
          Expanded(
            child: AppFilterChip(
              label: 'All shared',
              selected: !availableOnly,
              paddedTapTarget: true,
              onSelected: (_) => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}
