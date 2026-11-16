import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 40,
    this.backgroundColor = AppColors.primaryFixed,
    this.foregroundColor = AppColors.onPrimaryFixedVariant,
  });

  final String name;
  final String? imageUrl;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final diameter = size;
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                width: diameter,
                height: diameter,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _initials(),
              )
            : _initials(),
      ),
    );
  }

  Widget _initials() {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: Text(
          initials.isEmpty ? '?' : initials,
          style: AppTypography.textTheme.labelLarge?.copyWith(
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}
