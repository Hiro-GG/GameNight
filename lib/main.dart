import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Estructura base: los Providers se registran conforme cada integrante
  // agrega su parte (catálogo en el paso 2 y biblioteca en el paso 3).
  runApp(const GameNightApp());
}
