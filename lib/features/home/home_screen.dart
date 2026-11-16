import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/shared/widgets/app_header.dart';
import '../../features/shared/widgets/app_search_field.dart';
import 'data/home_mock_data.dart';
import 'widgets/discover_circle_books_banner.dart';
import 'widgets/home_circulation_card.dart';
import 'widgets/home_greeting.dart';
import 'widgets/home_library_card.dart';
import 'widgets/home_reading_circle_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.data = homeMockData});

  final HomeDashboardData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppHeader(
          sectionLabel: 'Home',
          profileName: data.memberName,
          profileImageUrl: data.memberAvatarUrl,
          onNotificationsTap: () => _showComingSoon(context, 'Notifications'),
          onProfileTap: () => _showComingSoon(context, 'Profile'),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageMargin,
              AppSpacing.spaceSm,
              AppSpacing.pageMargin,
              AppSpacing.spaceLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeGreeting(data: data),
                const SizedBox(height: AppSpacing.gutterCompact),
                AppSearchField(
                  hintText: 'Search your books, friends, or discussions...',
                  readOnly: true,
                  onTap: () => _showComingSoon(context, 'Search'),
                ),
                const SizedBox(height: AppSpacing.gutter),
                HomeLibraryCard(
                  data: data,
                  onViewLibrary: () => _showComingSoon(context, 'My Library'),
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                HomeCirculationCard(
                  data: data,
                  onDecline: () =>
                      _showComingSoon(context, 'Declining requests'),
                  onDetails: () => _showComingSoon(context, 'Loan details'),
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                HomeReadingCircleCard(
                  post: data.readingCirclePost,
                  onReflectionsTap: () =>
                      _showComingSoon(context, 'Reading reflections'),
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                DiscoverCircleBooksBanner(
                  titleCount: data.discoverTitleCount,
                  onTap: () => _showComingSoon(context, 'Discover'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static void _showComingSoon(BuildContext context, String feature) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature is not available yet.')));
  }
}
