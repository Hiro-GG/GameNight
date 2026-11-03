import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/core_theme.dart';
import '../../core/widgets/game_night_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  late final Animation<double> _escala = Tween(
    begin: 0.85,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  late final Animation<double> _opacidad = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    decidirDestino();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Por ahora siempre va al onboarding. En el paso 6 se recuerda si ya se vio.
  Future<void> decidirDestino() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    // Fondo oscuro: íconos de la barra de estado en blanco.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3A3690), AppColors.primario],
            ),
          ),
          child: FadeTransition(
            opacity: _opacidad,
            child: ScaleTransition(
              scale: _escala,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const GameNightLogo(size: 120),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'GameNight',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs + 2),
                  Text(
                    'Descubre juegos de mesa',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
