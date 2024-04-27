import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/mockito.dart';
import 'package:mp5/views/homePage.dart';
//import '../lib/models/weatherService.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'dart:ui';

void main() {
  group('WeatherService', () {
    testWidgets('HomePage widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.text('City Weather List'), findsOneWidget);

      // Tap on the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Ensure the CitySelectionPage is pushed and popped
      expect(find.text('Select Cities'), findsOneWidget);
    });

    testWidgets('UI Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is BackdropFilter,
        ),
        findsOneWidget,
      );
    });
  });
}
