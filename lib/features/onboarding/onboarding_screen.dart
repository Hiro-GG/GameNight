import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/core_theme.dart';
import '../../core/widgets/custom_button.dart';

class _PaginaOnboarding {
  final String imagen;
  final String titulo;
  final String texto;
  const _PaginaOnboarding(this.imagen, this.titulo, this.texto);
}

const _paginas = [
  _PaginaOnboarding(
    'assets/images/onboarding/descubre.png',
    'Descubre nuevos juegos',
    'Explora un catálogo de juegos de mesa con su categoría, duración, dificultad y edad recomendada.',
  ),
  _PaginaOnboarding(
    'assets/images/onboarding/filtra.png',
    'El juego ideal para tu grupo',
    'Dinos cuántos son y cuánto tiempo tienen, y te sugerimos opciones que sí encajan.',
  ),
  _PaginaOnboarding(
    'assets/images/onboarding/guarda.png',
    'Guarda tus favoritos',
    'Arma tu lista de favoritos y de juegos por probar para la próxima reunión.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int paginaActual = 0;

  bool get esUltima => paginaActual == _paginas.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void terminar() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void siguiente() {
    if (esUltima) {
      terminar();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla clara sin AppBar: íconos de la barra de estado oscuros.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: AnimatedOpacity(
                    opacity: esUltima ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: TextButton(
                      onPressed: esUltima ? null : terminar,
                      child: const Text('Saltar'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _paginas.length,
                  onPageChanged: (index) =>
                      setState(() => paginaActual = index),
                  itemBuilder: (context, index) {
                    final pagina = _paginas[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(pagina.imagen, width: 320),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            pagina.titulo,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.md - 4),
                          Text(
                            pagina.texto,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _paginas.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == paginaActual ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == paginaActual
                                  ? AppColors.primario
                                  : AppColors.primario.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: esUltima ? 'Comenzar' : 'Siguiente',
                        icon: esUltima ? Icons.casino_outlined : null,
                        onPressed: siguiente,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
