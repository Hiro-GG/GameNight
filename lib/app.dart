import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/core_theme.dart';

class GameNightApp extends StatelessWidget {
  const GameNightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameNight',
      debugShowCheckedModeBanner: false,
      theme: buildGameNightTheme(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
