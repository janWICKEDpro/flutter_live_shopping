import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_shopping/models/live_event.dart';
import 'package:flutter_live_shopping/models/product.dart';
import 'package:flutter_live_shopping/widgets/common/event_card.dart';
import 'package:flutter_live_shopping/widgets/live/product_card_compact.dart';
import 'package:flutter_live_shopping/providers/cart_provider.dart';
import 'package:flutter_live_shopping/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  group('EventCard Widget Tests', () {
    testWidgets('EventCard displays event information correctly', (
      WidgetTester tester,
    ) async {
      final event = LiveEvent.mock();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EventCard(event: event)),
        ),
      );

      // Verify event title is displayed
      expect(find.text(event.title), findsOneWidget);

      // Verify seller name is displayed
      expect(find.text(event.seller.name), findsOneWidget);
    });

    testWidgets('EventCard shows LIVE badge when status is live', (
      WidgetTester tester,
    ) async {
      final event = LiveEvent.mock().copyWith(status: LiveEventStatus.live);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EventCard(event: event)),
        ),
      );

      // Verify LIVE badge is shown
      expect(find.text('LIVE'), findsOneWidget);
    });
  });

  group('ProductCardCompact Widget Tests', () {
    testWidgets('ProductCardCompact displays product information', (
      WidgetTester tester,
    ) async {
      final product = Product.mock();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => CartProvider(MockApiService()),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: ProductCardCompact(product: product)),
          ),
        ),
      );

      // Verify product name is displayed
      expect(find.text(product.name), findsOneWidget);

      // Verify price is displayed
      expect(find.textContaining('\$'), findsAtLeastNWidgets(1));

      // Verify ADD button exists
      expect(find.text('ADD'), findsOneWidget);
    });

    testWidgets(
      'ProductCardCompact shows FEATURED badge when isFeatured is true',
      (WidgetTester tester) async {
        final product = Product.mock();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => CartProvider(MockApiService()),
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: ProductCardCompact(product: product, isFeatured: true),
              ),
            ),
          ),
        );

        // Verify FEATURED badge is shown
        expect(find.text('FEATURED'), findsOneWidget);
      },
    );

    testWidgets('ProductCardCompact ADD button adds product to cart', (
      WidgetTester tester,
    ) async {
      final product = Product.mock();
      final cartProvider = CartProvider(MockApiService());

      await tester.pumpWidget(
        MultiProvider(
          providers: [ChangeNotifierProvider.value(value: cartProvider)],
          child: MaterialApp(
            home: Scaffold(body: ProductCardCompact(product: product)),
          ),
        ),
      );

      // Verify cart is initially empty
      expect(cartProvider.items.length, 0);

      // Tap ADD button
      await tester.tap(find.text('ADD'));
      await tester.pumpAndSettle();

      // Verify product was added to cart
      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.first.product.id, product.id);
    });
  });
}
