import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_shopping/app.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const LiveShoppingApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
