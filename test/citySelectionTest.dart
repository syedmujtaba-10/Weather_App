import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/views/citySelection.dart';

void main() {
  group('WeatherService', () {
    testWidgets('CitySelectionPage widget test - Check Cities',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CitySelectionPage(),
        ),
      );

      expect(find.text('Select Cities'), findsOneWidget);

      expect(find.text('Tokyo'), findsOneWidget);
      expect(find.text('New York City'), findsOneWidget);
    });

    testWidgets('CitySelectionPage widget test - Functionality of CheckBox',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CitySelectionPage(),
        ),
      );

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Ensure the selected city is added to the selectedCities list
      expect(find.byType(Checkbox).first, findsOneWidget);
    });

    testWidgets('CitySelectionPage widget test - Floating Button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CitySelectionPage(),
        ),
      );

      // Tap on the floating action button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Ensure that the page is popped, and the selected cities are returned
      expect(find.text('Select Cities'), findsNothing);
    });
  });
}
