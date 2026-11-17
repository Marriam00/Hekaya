import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/models.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_buttons.dart';
import '../shared/widgets/app_filter_chip.dart';
import '../shared/widgets/app_header.dart';
import '../shared/widgets/app_search_field.dart';
import '../shared/widgets/status_badge.dart';
import 'widgets/library_book_card.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({
    super.key,
    required this.onAddBook,
    required this.onOpenBook,
    required this.onEditBook,
    required this.onOpenProfile,
  });

  final VoidCallback onAddBook;
  final ValueChanged<String> onOpenBook;
  final ValueChanged<String> onEditBook;
  final VoidCallback onOpenProfile;

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _selectedGenre = 'All';
  String _query = '';

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
        final allBooks = repositories.books.books
            .where((book) => book.ownerId == currentProfile.id)
            .toList();
        final loans = repositories.lending.loans;
        final genres = <String>{'All', ...allBooks.map((book) => book.genre)}
            .toList()
          ..sort();
        final visibleBooks = allBooks.where((book) {
          final isLent = loans.any(
            (loan) =>
                loan.bookId == book.id && loan.status == LoanStatus.active,
          );
          final matchesFilter = switch (_selectedFilter) {
            'Public' => book.visibility == BookVisibility.public,
            'Private' => book.visibility == BookVisibility.private,
            'Lent Out' => isLent,
            _ => true,
          };
          final matchesGenre =
              _selectedGenre == 'All' || book.genre == _selectedGenre;
          final normalized = _query.trim().toLowerCase();
          final matchesQuery = normalized.isEmpty ||
              '${book.title} ${book.author}'.toLowerCase().contains(normalized);
          return matchesFilter && matchesGenre && matchesQuery;
        }).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return Column(
          children: [
            AppHeader(
              sectionLabel: 'My Library',
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final title = Row(
                        children: [
                          Expanded(
                            child: Text(
                              'My Library',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          StatusBadge(label: '${allBooks.length} books'),
                        ],
                      );
                      final addBook = AppPrimaryButton(
                        label: 'Add Book',
                        icon: Icons.add_rounded,
                        onPressed: widget.onAddBook,
                      );
                      if (constraints.maxWidth < 380) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            title,
                            const SizedBox(height: AppSpacing.spaceSm),
                            Align(
                              alignment: Alignment.centerRight,
                              child: addBook,
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: title),
                          const SizedBox(width: AppSpacing.spaceSm),
                          addBook,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.gutterCompact),
                  AppSearchField(
                    controller: _searchController,
                    hintText: 'Search title or author...',
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: AppSpacing.gutterCompact),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final filter in [
                          'All',
                          'Public',
                          'Private',
                          'Lent Out',
                        ]) ...[
                          if (filter != 'All')
                            const SizedBox(width: AppSpacing.spaceSm),
                          AppFilterChip(
                            label: '$filter (${_countFor(filter, allBooks, loans)})',
                            selected: _selectedFilter == filter,
                            paddedTapTarget: true,
                            onSelected: (_) =>
                                setState(() => _selectedFilter = filter),
                          ),
                        ],
                      ],
                    ),
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
                            selected: _selectedGenre == genre,
                            paddedTapTarget: true,
                            onSelected: (_) =>
                                setState(() => _selectedGenre = genre),
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
                        'No books match these filters.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    for (final book in visibleBooks) ...[
                      LibraryBookCard(
                        book: book,
                        isLent: loans.any(
                          (loan) =>
                              loan.bookId == book.id &&
                              loan.status == LoanStatus.active,
                        ),
                        onOpen: () => widget.onOpenBook(book.id),
                        onEdit: () => widget.onEditBook(book.id),
                        onToggleVisibility: () =>
                            repositories.books.setVisibility(
                              book.id,
                              book.visibility == BookVisibility.public
                                  ? BookVisibility.private
                                  : BookVisibility.public,
                            ),
                        onViewNotes: () => _showNotes(book),
                        onDelete: () => _confirmDelete(book),
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

  int _countFor(String filter, List<Book> books, List<Loan> loans) {
    return books.where((book) {
      final isLent = loans.any(
        (loan) => loan.bookId == book.id && loan.status == LoanStatus.active,
      );
      return switch (filter) {
        'Public' => book.visibility == BookVisibility.public,
        'Private' => book.visibility == BookVisibility.private,
        'Lent Out' => isLent,
        _ => true,
      };
    }).length;
  }

  void _showNotes(Book book) {
    final notes = RepositoryScope.of(context).books.notesFor(book.id);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Private notes · ${book.title}'),
        content: SingleChildScrollView(
          child: Text(
            notes.isEmpty ? 'No private notes.' : notes.map((e) => e.content).join('\n\n'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Book book) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete book?'),
        content: Text('“${book.title}” will be removed from your library.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true && mounted) {
      await RepositoryScope.of(context).deleteBook(book.id);
    }
  }
}
