import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/models.dart';
import 'app_buttons.dart';

Future<String?> showBorrowRequestDialog(
  BuildContext context, {
  required Book book,
  required Profile owner,
}) async {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.panel)),
    ),
    builder: (sheetContext) => _BorrowRequestSheet(book: book, owner: owner),
  );
}

class _BorrowRequestSheet extends StatefulWidget {
  const _BorrowRequestSheet({required this.book, required this.owner});

  final Book book;
  final Profile owner;

  @override
  State<_BorrowRequestSheet> createState() => _BorrowRequestSheetState();
}

class _BorrowRequestSheetState extends State<_BorrowRequestSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.gutter,
            AppSpacing.gutter,
            AppSpacing.gutter + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Request “${widget.book.title}”',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                'Owned by ${widget.owner.displayName}',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.gutter),
              TextField(
                controller: _controller,
                minLines: 2,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Note to owner (optional)',
                ),
              ),
              const SizedBox(height: AppSpacing.gutter),
              Row(
                children: [
                  Expanded(
                    child: AppSecondaryButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Expanded(
                    child: AppPrimaryButton(
                      label: 'Send',
                      onPressed: () =>
                          Navigator.of(context).pop(_controller.text),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
