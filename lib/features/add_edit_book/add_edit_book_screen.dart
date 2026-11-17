import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/models.dart';
import '../../data/repositories/books_repository.dart';
import '../../data/repositories/repository_scope.dart';
import '../shared/widgets/app_buttons.dart';
import '../shared/widgets/app_filter_chip.dart';
import '../shared/widgets/app_header.dart';
import '../shared/widgets/book_cover_card.dart';

class AddEditBookScreen extends StatefulWidget {
  const AddEditBookScreen({super.key, this.bookId, required this.onSaved});

  final String? bookId;
  final VoidCallback onSaved;

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  String _genre = 'Fiction';
  BookVisibility? _visibility;
  bool _allowLending = false;
  bool _initialized = false;
  bool _saving = false;

  static const _genres = [
    'Fiction',
    'Mystery',
    'Philosophy',
    'Poetry',
    'History',
    'Memoir',
    'Essays',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repositories = RepositoryScope.of(context);
    final existingBook = widget.bookId == null
        ? null
        : repositories.books.findBook(widget.bookId!);
    if (!_initialized) {
      _initialize(repositories.books, existingBook);
    }

    return Column(
      children: [
        AppHeader(
          showBrand: false,
          sectionLabel: existingBook == null ? 'Add Book' : 'Edit Book',
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageMargin,
                AppSpacing.spaceSm,
                AppSpacing.pageMargin,
                AppSpacing.spaceXl,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        existingBook == null ? 'Add Book' : 'Edit Book',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onSaved,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.gutter),
                _coverSection(existingBook),
                const SizedBox(height: AppSpacing.gutter),
                _textField(
                  controller: _titleController,
                  label: 'Title',
                  requiredField: true,
                ),
                const SizedBox(height: AppSpacing.gutterCompact),
                _textField(
                  controller: _authorController,
                  label: 'Author',
                  requiredField: true,
                ),
                const SizedBox(height: AppSpacing.gutterCompact),
                Text('Genre', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSpacing.spaceSm),
                Wrap(
                  spacing: AppSpacing.spaceSm,
                  runSpacing: AppSpacing.spaceSm,
                  children: [
                    for (final genre in _genres)
                      AppFilterChip(
                        label: genre,
                        selected: _genre == genre,
                        paddedTapTarget: true,
                        onSelected: (_) => setState(() => _genre = genre),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.gutterCompact),
                _textField(
                  controller: _descriptionController,
                  label: 'Description',
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.gutter),
                Text(
                  'Visibility',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                Wrap(
                  spacing: AppSpacing.spaceSm,
                  children: [
                    AppFilterChip(
                      label: 'Public',
                      selected: _visibility == BookVisibility.public,
                      paddedTapTarget: true,
                      onSelected: (_) =>
                          setState(() => _visibility = BookVisibility.public),
                    ),
                    AppFilterChip(
                      label: 'Private',
                      selected: _visibility == BookVisibility.private,
                      paddedTapTarget: true,
                      onSelected: (_) =>
                          setState(() => _visibility = BookVisibility.private),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Allow lending'),
                  value: _allowLending,
                  onChanged: _visibility == BookVisibility.private
                      ? null
                      : (value) => setState(() => _allowLending = value),
                ),
                const SizedBox(height: AppSpacing.gutterCompact),
                _textField(
                  controller: _notesController,
                  label: 'Private notes',
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.gutter),
                AppPrimaryButton(
                  label: _saving ? 'Saving…' : 'Save Book',
                  onPressed: _saving ? null : () => _save(existingBook),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _coverSection(Book? book) {
    return Card(
      color: AppColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Row(
          children: [
            BookCoverCard(
              title: book?.title ?? 'Book cover',
              coverReference: book?.coverUrl,
              width: AppSpacing.bookCoverWidth,
              showMetadata: false,
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Text(
                'Book cover',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool requiredField = false,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: label),
      validator: requiredField
          ? (value) =>
                value == null || value.trim().isEmpty ? 'Enter a $label.' : null
          : null,
    );
  }

  void _initialize(BooksRepository booksRepository, Book? book) {
    _initialized = true;
    _titleController.text = book?.title ?? '';
    _authorController.text = book?.author ?? '';
    _descriptionController.text = book?.description ?? '';
    _notesController.text = book == null
        ? ''
        : booksRepository
              .notesFor(book.id)
              .map((note) => note.content)
              .join('\n');
    _genre = book?.genre ?? _genres.first;
    _visibility = book?.visibility ?? booksRepository.defaultVisibility;
    _allowLending = book?.allowLending ?? false;
  }

  Future<void> _save(Book? existingBook) async {
    if (!_formKey.currentState!.validate()) return;
    final repositories = RepositoryScope.of(context);
    final currentProfile = repositories.profiles.currentProfile;
    final visibility = _visibility ?? BookVisibility.public;
    setState(() => _saving = true);
    final book = Book(
      id: existingBook?.id ?? 'book-${DateTime.now().microsecondsSinceEpoch}',
      ownerId: existingBook?.ownerId ?? currentProfile.id,
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      coverUrl: existingBook?.coverUrl ?? '',
      description: _descriptionController.text.trim(),
      genre: _genre,
      visibility: visibility,
      allowLending: visibility == BookVisibility.public && _allowLending,
      readingStatus: existingBook?.readingStatus ?? ReadingStatus.toRead,
      createdAt: existingBook?.createdAt ?? DateTime.now(),
    );
    try {
      await repositories.books.saveBook(
        book,
        privateNote: _notesController.text,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
    if (mounted) widget.onSaved();
  }
}
