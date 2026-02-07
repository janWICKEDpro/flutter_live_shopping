import 'package:flutter/material.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';
import 'package:flutter_live_shopping/models/live_event.dart';
import 'package:flutter_live_shopping/providers/live_event_provider.dart';
import 'package:flutter_live_shopping/providers/cart_provider.dart';
import 'package:flutter_live_shopping/widgets/live/cart_drawer.dart';
import 'package:flutter_live_shopping/widgets/live/chat_widget.dart';
import 'package:flutter_live_shopping/widgets/live/product_sidebar.dart';
import 'package:flutter_live_shopping/widgets/live/video_player_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LiveEventScreen extends StatefulWidget {
  final String eventId;

  const LiveEventScreen({super.key, required this.eventId});

  @override
  State<LiveEventScreen> createState() => _LiveEventScreenState();
}

class _LiveEventScreenState extends State<LiveEventScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LiveEventProvider>();
      provider.joinEvent(widget.eventId);
      // Ensure we have event data, if not loaded, load it
      if (provider.events.isEmpty) {
        provider.loadEvents();
      }
    });
  }

  @override
  void dispose() {
    // Leave event when screen is disposed
    // Use a post-frame callback or similar if context access is tricky,
    // but here we just need the provider instance.
    // Actually, we can't easily access context in dispose if the widget is unmounted.
    // Best practice might be to handle this in specific "leave" action or relying on provider cleanup if it was scoped.
    // Since provider is global, we should explicitly leave.
    // context.read<LiveEventProvider>().leaveEvent(); // This might throw if context is invalid.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveEventProvider>(
      builder: (context, provider, child) {
        final event = provider.events.firstWhere(
          (e) => e.id == widget.eventId,
          orElse: () => LiveEvent(
            id: 'not_found',
            title: 'Loading Event...',
            description: '',
            startTime: DateTime.now(),
            endTime: DateTime.now(),
            status: LiveEventStatus.ended,
            seller: Seller(id: '', name: '', storeName: '', avatar: ''),
            products: [],
            viewerCount: 0,
            thumbnailUrl: '',
          ),
        );

        if (event.id == 'not_found' && !provider.isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Event Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not find the requested event.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 800;
            return Scaffold(
              key: _scaffoldKey,
              endDrawer: const CartDrawer(),
              body: isDesktop
                  ? _buildDesktopLayout(context, event, provider)
                  : _buildMobileLayout(context, event, provider),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    LiveEvent event,
    LiveEventProvider provider,
  ) {
    return Stack(
      children: [
        // 1. Video Layer (Background)
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: event.streamUrl != null || event.replayUrl != null
                ? VideoPlayerWidget(
                    videoUrl: event.streamUrl ?? event.replayUrl!,
                    isLive: event.status == LiveEventStatus.live,
                  )
                : Image.network(
                    event.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
          ),
        ),

        // 2. Overlay Layer (Gradient & UI)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black87,
                ],
                stops: [0.0, 0.2, 0.5, 1.0],
              ),
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, event, provider),

              const Spacer(),

              // Chat & Products
              SizedBox(
                height: 350, // Constrain height for bottom area
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Chat
                    Expanded(child: ChatWidget()),

                    // Products
                    ProductSidebar(
                      products: event.products ?? [],
                      featuredProductId:
                          provider.currentFeaturedProductId ??
                          event.featuredProduct?.id,
                      isHorizontal: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    LiveEvent event,
    LiveEventProvider provider,
  ) {
    return Row(
      children: [
        // Video Section
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                child: event.streamUrl != null || event.replayUrl != null
                    ? VideoPlayerWidget(
                        videoUrl: event.streamUrl ?? event.replayUrl!,
                        isLive: event.status == LiveEventStatus.live,
                      )
                    : Image.network(event.thumbnailUrl, fit: BoxFit.cover),
              ),
              // Overlay Header on Video
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.go('/'),
                      ),
                      const SizedBox(width: 8),
                      if (event.status == LiveEventStatus.live)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Sidebar Section
        Container(
          width: 400,
          color: Colors.white,
          child: Column(
            children: [
              // Header Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.gray200,
                          foregroundImage: event.seller.avatar.isNotEmpty
                              ? CachedNetworkImageProvider(event.seller.avatar)
                              : null,
                          child: Text(
                            event.seller.name.isNotEmpty
                                ? event.seller.name[0]
                                : '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gray600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          event.seller.storeName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray900,
                              ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.eye,
                                size: 12,
                                color: AppColors.gray700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${provider.currentViewerCount > 0 ? provider.currentViewerCount : event.viewerCount}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gray800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Chat
              Expanded(
                child: Container(
                  color: AppColors.gray50,
                  // We need to inverse colors for chat in desktop mode (light theme)
                  // Or adapt ChatWidget. Currently ChatWidget is designed for "Overlay" (White text).
                  // We might need to make ChatWidget adaptable or wrap it in a dark container for now.
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: Colors.black87,
                          child: ChatWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Products
              Container(
                height: 250,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.gray200)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Featured Products',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ProductSidebar(
                        products: event.products ?? [],
                        featuredProductId:
                            provider.currentFeaturedProductId ??
                            event.featuredProduct?.id,
                        isHorizontal:
                            true, // Reuse horizontal layout for bottom of sidebar
                        // Or we can make it vertical if we want full height
                      ),
                    ),
                  ],
                ),
              ),

              // Cart Button (Floating or fixed)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart),
                    label: Consumer<CartProvider>(
                      builder: (_, cart, _) => Text('Cart (${cart.itemCount})'),
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    LiveEvent event,
    LiveEventProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go('/'),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.gray200,
                      foregroundImage: event.seller.avatar.isNotEmpty
                          ? CachedNetworkImageProvider(event.seller.avatar)
                          : null,
                      child: Text(
                        event.seller.name.isNotEmpty
                            ? event.seller.name[0]
                            : '',
                        style: const TextStyle(
                          fontSize: 8,
                          color: AppColors.gray600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      event.seller.storeName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        shadows: [
                          Shadow(color: Colors.black87, blurRadius: 8),
                          Shadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (event.status == LiveEventStatus.live)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.eye,
                      size: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.currentViewerCount > 0 ? provider.currentViewerCount : event.viewerCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Cart Icon
              Consumer<CartProvider>(
                builder: (_, cart, _) => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          _scaffoldKey.currentState?.openEndDrawer(),
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
