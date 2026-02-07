import 'package:go_router/go_router.dart';
import 'package:flutter_live_shopping/screens/home/home_screen.dart';
import 'package:flutter_live_shopping/screens/live/live_event_screen.dart';
import 'package:flutter_live_shopping/screens/product/product_detail_screen.dart';
import 'package:flutter_live_shopping/screens/profile/profile_screen.dart';

// Private router instance to allow hot reload to work properly with GoRouter
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/live/:id',
      builder: (context, state) =>
          LiveEventScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) =>
          ProductDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

GoRouter get router => _router;
