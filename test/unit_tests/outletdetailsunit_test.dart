import 'package:flexpaymerchandiser/features/screens/outletdetailspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flexpaymerchandiser/features/screens/homescreen.dart'; // Adjust the import path based on your file structure

// Mock the HTTP client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('OutletDetailsPage', () {
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });

    testWidgets('displays loading indicator when data is being fetched', (WidgetTester tester) async {
      // Mock the response for the fetchOutletDetails method to return nothing (simulate loading)
      when(mockHttpClient.post(
  Uri.parse('https://bookings.flexpay.co.ke/api/merchandizer/customers'),
  headers: anyNamed('headers'), 
  body: anyNamed('body')))
    .thenAnswer((_) async => http.Response('{"success": true, "data": {}}', 200));
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: OutletDetailsPage(outletId: '1'),
        ),
      );

      // Wait for the widget to settle and verify the loading indicator is present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when fetching fails', (WidgetTester tester) async {
      // Simulate an error response from the mock HTTP client
      when(mockHttpClient.post(Uri.parse('https://bookings.flexpay.co.ke/api/merchandizer/customers'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"success": false}', 500));

      await tester.pumpWidget(
        MaterialApp(
          home: OutletDetailsPage(outletId: '1'),
        ),
      );

      // Wait for the widget to settle and verify the error message is shown
      await tester.pumpAndSettle();
      expect(find.text('Failed to fetch data'), findsOneWidget);
    });

  testWidgets('displays customer details when fetched successfully', (WidgetTester tester) async {
  final mockResponse = '''
    {
      "success": true,
      "data": {
        "data": [
          {
            "date_created": "2021-01-01",
            "customer_name": "John Doe",
            "phone": "1234567890",
            "is_flexsave_customer": 1
          }
        ]
      }
    }
  ''';

  // Mock successful response
  when(mockHttpClient.post(
    Uri.parse('https://bookings.flexpay.co.ke/api/merchandizer/customers'),
    headers: anyNamed('headers'), body: anyNamed('body')))
    .thenAnswer((_) async => http.Response(mockResponse, 200));

  await tester.pumpWidget(
    MaterialApp(
      home: OutletDetailsPage(outletId: '1'),
    ),
  );

  // Wait for the widget to settle and verify customer details are shown
  await tester.pumpAndSettle();
  expect(find.text('John Doe'), findsOneWidget);
  expect(find.text('1234567890'), findsOneWidget);
});

    testWidgets('displays no customer details message when outletDetails is empty', (WidgetTester tester) async {
      final mockResponse = '''
        {
          "success": true,
          "data": {
            "data": []
          }
        }
      ''';

      // Mock response with empty data
      when(mockHttpClient.post(
        Uri.parse('https://bookings.flexpay.co.ke/api/merchandizer/customers'),
       headers: anyNamed('headers'), 
       body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      await tester.pumpWidget(
        MaterialApp(
          home: OutletDetailsPage(outletId: '1'),
        ),
      );

      // Wait for the widget to settle and verify no customer details message is shown
      await tester.pumpAndSettle();
      expect(find.text('No customer details found.'), findsOneWidget);
    });
  });
}