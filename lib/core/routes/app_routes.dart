import 'package:flutter/material.dart';

import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case onboarding:
        return _fundido(settings, const OnboardingScreen());
      case home:
        return _fundido(settings, const HomeScreen());
      default:
        return _rutaDesconocida(settings);
    }
  }

  // Splash → Onboarding → Home se sienten como una sola entrada, por eso
  // se usa un fundido en lugar del deslizamiento normal de página.
  static Route<dynamic> _fundido(RouteSettings settings, Widget pantalla) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => pantalla,
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    );
  }

  static Route<dynamic> _rutaDesconocida(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
      ),
    );
  }
}
