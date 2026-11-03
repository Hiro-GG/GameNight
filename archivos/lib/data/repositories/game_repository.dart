import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/game_model.dart';

/// Contrato de la fuente de juegos. Las pantallas y los Providers solo
/// conocen esta clase; en la Etapa 2 se agrega `FirestoreGameRepository`
/// y se cambia una línea en `main.dart`.
abstract class GameRepository {
  Future<List<Game>> obtenerJuegos();
}

/// Etapa 1: lee el catálogo desde `assets/data/games.json`.
class LocalGameRepository implements GameRepository {
  final AssetBundle _bundle;
  final String ruta;

  LocalGameRepository({
    AssetBundle? bundle,
    this.ruta = 'assets/data/games.json',
  }) : _bundle = bundle ?? rootBundle;

  @override
  Future<List<Game>> obtenerJuegos() async {
    final texto = await _bundle.loadString(ruta);
    final lista = jsonDecode(texto) as List<dynamic>;
    return lista
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
