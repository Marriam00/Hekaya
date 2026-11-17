import 'package:flutter/widgets.dart';

class BookCoverImage extends StatelessWidget {
  const BookCoverImage({super.key, required this.reference});

  final String reference;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      reference,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
