import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';
import 'package:flutter_live_shopping/models/live_event.dart';
import 'package:flutter_live_shopping/providers/live_event_provider.dart';
import 'package:flutter_live_shopping/widgets/common/event_card.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  // We'll track local filter state to update UI immediately, though provider handles logic
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveEventProvider>().loadEvents();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<LiveEventProvider>().loadEvents();
        },
        color: AppColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(context),
            _buildSearchBar(context),

            // Content
            Consumer<LiveEventProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return SliverFillRemaining(child: _buildShimmerLoading());
                }

                if (provider.error != null) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(provider.error!),
                          TextButton(
                            onPressed: () => provider.loadEvents(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // If no events match filters
                if (provider.liveEvents.isEmpty &&
                    provider.upcomingEvents.isEmpty &&
                    provider.pastEvents.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('No events found matching your search.'),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildListDelegate([
                    if (provider.liveEvents.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        'Live Now',
                        icon: Icons.circle,
                        iconColor: AppColors.primary,
                      ),
                      _buildHorizontalList(provider.liveEvents),
                    ],

                    if (provider.upcomingEvents.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        'Upcoming Events',
                        icon: Icons.calendar_today,
                        iconColor: AppColors.secondary,
                      ),
                      _buildHorizontalList(provider.upcomingEvents),
                    ],

                    if (provider.pastEvents.isNotEmpty) ...[
                      _buildSectionHeader(context, 'Past Streams'),
                      _buildResponsiveGrid(provider.pastEvents, context),
                    ],

                    const SizedBox(height: 80), // Bottom padding
                  ]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 24, width: 120, color: Colors.white),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Container(height: 200, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(child: Container(height: 200, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 32),
            Container(height: 24, width: 180, color: Colors.white),
            const SizedBox(height: 16),
            Container(height: 200, width: double.infinity, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              FontAwesomeIcons.bagShopping,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Odama',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              letterSpacing: -0.5,
              color: AppColors.gray900,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(FontAwesomeIcons.bell), onPressed: () {}),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.gray200,
          backgroundImage: const NetworkImage(
            'https://i.pravatar.cc/150?img=68',
          ),
          onBackgroundImageError: (_, __) {},
          child: const Text(
            'JD',
            style: TextStyle(fontSize: 10, color: AppColors.gray700),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: AppColors.white,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search events, products, or sellers...',
                prefixIcon: const Icon(Icons.search, color: AppColors.gray500),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                context.read<LiveEventProvider>().setSearchQuery(value);
              },
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Map categories to list. For now hardcode typical ones matching mock data
                  for (var cat in ['All', 'Mode', 'Beauté', 'Électronique'])
                    _buildFilterChip(cat),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedCategory == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = label;
          });
          context.read<LiveEventProvider>().setCategoryFilter(label);
        },
        backgroundColor: AppColors.white,
        selectedColor: AppColors.gray900,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.gray700,
          fontWeight: FontWeight.w600,
        ),
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isSelected
              ? BorderSide.none
              : const BorderSide(color: AppColors.gray300),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: iconColor ?? AppColors.gray900),
            const SizedBox(width: 8),
          ],
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              fontSize: 14,
              color:
                  AppColors.gray800, // Slightly lighter than black for headers
            ),
          ),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('See All')),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<LiveEvent> events) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 280, // Constrain width here since card is responsive
            child: EventCard(event: events[index]),
          );
        },
      ),
    );
  }

  Widget _buildResponsiveGrid(List<LiveEvent> events, BuildContext context) {
    // For past streams, we use a grid that adapts to screen width
    // On mobile, maybe just a vertical list or 1 column. On Tablet 2, Desktop 3+.

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 1;
        if (width > 600) crossAxisCount = 2;
        if (width > 900) crossAxisCount = 3;
        if (width > 1200) crossAxisCount = 4;

        if (crossAxisCount == 1) {
          // List view for mobile
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => EventCard(event: events[index]),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.8, // Adjust based on card content
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) =>
              EventCard(event: events[index], compact: true),
        );
      },
    );
  }
}
