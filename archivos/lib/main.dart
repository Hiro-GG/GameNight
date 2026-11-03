import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/game_repository.dart';
import 'features/catalog/catalog_provider.dart';

void main() {
  // Necesario para usar plugins antes de runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Etapa 1: datos locales. En la Etapa 2 solo cambia esta línea por la
  // versión con Firebase; Providers y pantallas quedan igual.
  final GameRepository gameRepository = LocalGameRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CatalogProvider(gameRepository)..cargarJuegos(),
        ),
      ],
      child: const GameNightApp(),
    ),
  );
}
