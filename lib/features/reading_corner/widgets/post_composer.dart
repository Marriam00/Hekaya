import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/models.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/app_filter_chip.dart';

class PostComposer extends StatefulWidget {
  const PostComposer({super.key, required this.books, required this.onPublish});

  final List<Book> books;
  final void Function(String content, String? bookId, PostType type) onPublish;

  @override
  State<PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends State<PostComposer> {
  final _controller = TextEditingController();
  String _bookId = '';
  PostType _type = PostType.thought;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Share a thought with your reading circle...',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            DropdownButtonFormField<String>(
              initialValue: _bookId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Linked book'),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('No linked book'),
                ),
                for (final book in widget.books)
                  DropdownMenuItem(
                    value: book.id,
                    child: Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) => setState(() => _bookId = value ?? ''),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Wrap(
              spacing: AppSpacing.spaceSm,
              children: [
                AppFilterChip(
                  label: 'Thought',
                  selected: _type == PostType.thought,
                  paddedTapTarget: true,
                  onSelected: (_) => setState(() => _type = PostType.thought),
                ),
                AppFilterChip(
                  label: 'Question',
                  selected: _type == PostType.question,
                  paddedTapTarget: true,
                  onSelected: (_) => setState(() => _type = PostType.question),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Align(
              alignment: Alignment.centerRight,
              child: AppPrimaryButton(
                label: _type == PostType.thought
                    ? 'Publish Thought'
                    : 'Publish Question',
                icon: Icons.send_rounded,
                onPressed: _controller.text.trim().isEmpty
                    ? null
                    : () {
                        widget.onPublish(
                          _controller.text.trim(),
                          _bookId.isEmpty ? null : _bookId,
                          _type,
                        );
                        _controller.clear();
                        setState(() {});
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
