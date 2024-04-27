import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
//import '../lib/main.dart';
import 'package:mp5/views/homePage.dart';
//import 'package:http/testing.dart';
//import '../lib/models/weatherService.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Tap on the Add button to navigate to the CitySelectionPage
    await tester.tap(find.byIcon(Icons.add));

    // Wait for the navigation to complete
    await tester.pumpAndSettle();

    // Verify that we are on the CitySelectionPage
    expect(find.text('Select Cities'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Toronto'),
      100.0,
    );

    // Tap on the checkbox next to Torono
    final calgaryTileFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ListTile &&
          widget.title is Text &&
          widget.title.toString().contains('Toronto'),
    );

    // Find the Checkbox associated with Toronto and tap it
    final calgaryCheckboxFinder = find.descendant(
      of: calgaryTileFinder,
      matching: find.byType(Checkbox),
    );
    await tester.tap(calgaryCheckboxFinder);

    // Wait for the selection to be updated
    await tester.pump();

    // Tap on the Add button to add Toronto to the list
    await tester.tap(find.byType(FloatingActionButton));

    // Wait for the navigation back to the HomeScreen
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Toronto'),
      100.0,
    );

    // Verify that Toronto is now in the list
    expect(find.text('Toronto'), findsOneWidget);

    await tester.pumpAndSettle();

    // Tap on Toronto to open the WeatherDetailsPage
    await tester.tap(find.text('Toronto'));

    // Wait for the navigation to the WeatherDetailsPage
    await tester.pumpAndSettle();
    print('Done till Toronto');

    // Verify that we are on the WeatherDetailsPage for Toronto
    expect(find.text('Weather Details - Toronto'), findsOneWidget);
    print('#########--------DONE--------##########');
  });
}
