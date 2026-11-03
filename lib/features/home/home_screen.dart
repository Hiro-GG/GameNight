import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/empty_state.dart';

/// Contenedor principal con la barra de navegación inferior.
/// Usa IndexedStack para que cada pestaña conserve su scroll y su estado.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const int tabInicio = 0;
  static const int tabCatalogo = 1;
  static const int tabPlanear = 2;
  static const int tabMisJuegos = 3;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabActual = HomeScreen.tabInicio;

  void irA(int tab) {
    setState(() => tabActual = tab);
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla clara sin AppBar: íconos de la barra de estado oscuros.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(
          index: tabActual,
          children: [
            const _EnConstruccion(titulo: 'Inicio'),
            const _EnConstruccion(titulo: 'Catálogo'),
            const _EnConstruccion(titulo: 'Planear reunión'),
            const _EnConstruccion(titulo: 'Mis juegos'),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tabActual,
          onDestinationSelected: irA,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'Catálogo',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_note_outlined),
              selectedIcon: Icon(Icons.event_note_rounded),
              label: 'Planear',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmarks_outlined),
              selectedIcon: Icon(Icons.bookmarks_rounded),
              label: 'Mis juegos',
            ),
          ],
        ),
      ),
    );
  }
}

/// Pestaña temporal mientras el integrante responsable sube su pantalla.
class _EnConstruccion extends StatelessWidget {
  final String titulo;
  const _EnConstruccion({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: const EmptyState(
        icono: Icons.construction_rounded,
        titulo: 'En construcción',
        mensaje: 'Esta sección se agrega en el siguiente avance.',
      ),
    );
  }
}
