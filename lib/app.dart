import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_live_shopping/config/router.dart';
import 'package:flutter_live_shopping/config/theme_config.dart';
import 'package:flutter_live_shopping/services/api_service.dart';
import 'package:flutter_live_shopping/services/socket_service.dart';
import 'package:flutter_live_shopping/services/auth_service.dart';
import 'package:flutter_live_shopping/providers/live_event_provider.dart';
import 'package:flutter_live_shopping/providers/cart_provider.dart';
import 'package:flutter_live_shopping/providers/auth_provider.dart';
import 'package:flutter_live_shopping/utils/constants.dart';

class LiveShoppingApp extends StatelessWidget {
  const LiveShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => SocketService()),
        Provider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider2<
          ApiService,
          SocketService,
          LiveEventProvider
        >(
          create: (context) => LiveEventProvider(
            context.read<ApiService>(),
            context.read<SocketService>(),
          ),
          update: (_, api, socket, prev) =>
              prev ?? LiveEventProvider(api, socket),
        ),
        ChangeNotifierProxyProvider<ApiService, CartProvider>(
          create: (context) => CartProvider(context.read<ApiService>()),
          update: (_, api, prev) => prev ?? CartProvider(api),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
          update: (_, auth, prev) => prev ?? AuthProvider(auth),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
