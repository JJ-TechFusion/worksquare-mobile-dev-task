import 'package:flutter/material.dart';
import 'package:dreamdwell/core/routes/route_names.dart';
import 'package:dreamdwell/core/routes/route_arguments.dart';
import 'package:dreamdwell/features/splash/splashscreen.dart';
import 'package:dreamdwell/features/splash/onboarding/onboarding.dart';
import 'package:dreamdwell/features/pages/main_screen.dart';
import 'package:dreamdwell/features/pages/search_page.dart';
import 'package:dreamdwell/features/properties/properties.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const Splashscreen(),
          settings: settings,
        );
        
      case RouteNames.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
        
      case RouteNames.main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );
        
      case RouteNames.search:
        return MaterialPageRoute(
          builder: (_) => const SearchPage(),
          settings: settings,
        );
        
      case RouteNames.propertyDetails:
        final args = settings.arguments as PropertyDetailsArguments;
        return MaterialPageRoute(
          builder: (_) => PropertyDetailsPage(
            propertyId: args.propertyId,
          ),
          settings: settings,
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
