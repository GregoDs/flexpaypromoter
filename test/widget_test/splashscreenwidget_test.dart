import 'package:flexpaymerchandiser/features/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Splash screen displays logo and navigates to onboarding', (WidgetTester tester) async {
    // Set up the widget
    await tester.pumpWidget(
      MaterialApp(
        home: const SplashScreen(),
        routes: {'/onboarding': (context) => const Placeholder()},
      ),
    );

    // Verify the logo is displayed
    expect(find.byType(Image), findsOneWidget);
    expect(find.image(const AssetImage('assets/logos/logo.png')), findsOneWidget);

    // Verify the animation starts (fade-in effect)
    final fadeTransitionFinder = find.byType(FadeTransition);
    expect(fadeTransitionFinder, findsOneWidget);
    final FadeTransition fadeTransition = tester.widget(fadeTransitionFinder);
    expect(fadeTransition.opacity, isNotNull);

    // Fast forward time by 7 seconds to simulate navigation
    await tester.pumpAndSettle(const Duration(seconds: 7));

    // Verify navigation to the onboarding page
    expect(find.byType(Placeholder), findsOneWidget); // Placeholder simulates the onboarding page
  });
}

