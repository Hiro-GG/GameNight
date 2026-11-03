import 'package:flutter/material.dart';

import '../../data/repositories/game_repository.dart';
import '../../models/game_filter.dart';
import '../../models/game_model.dart';

/// Estado del catálogo: carga los juegos desde el Repository y aplica la
/// búsqueda y los filtros. Las pantallas solo leen [juegosFiltrados].
class CatalogProvider extends ChangeNotifier {
  final GameRepository _repository;

  CatalogProvider(this._repository);

  List<Game> _juegos = [];
  GameFilter _filtro = const GameFilter();
  bool _cargando = false;
  String? _error;

  List<Game> get juegos => List.unmodifiable(_juegos);
  GameFilter get filtro => _filtro;
  bool get cargando => _cargando;
  String? get error => _error;

  List<Game> get juegosFiltrados => _juegos.where(_filtro.coincide).toList();

  List<String> get categorias {
    final unicas = _juegos.map((j) => j.category).toSet().toList()..sort();
    return [GameFilter.todas, ...unicas];
  }

  /// Juegos sencillos y cortos para la sección "Para empezar" del inicio.
  List<Game> get destacados => _juegos
      .where((j) => j.difficulty == Difficulty.facil && j.durationMinutes <= 30)
      .take(6)
      .toList();

  Future<void> cargarJuegos() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _juegos = await _repository.obtenerJuegos();
    } catch (e) {
      _error = 'No se pudo cargar el catálogo';
      debugPrint('Error al cargar juegos: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Game? buscarPorId(String id) {
    for (final juego in _juegos) {
      if (juego.id == id) return juego;
    }
    return null;
  }

  /// Convierte ids guardados (favoritos, pendientes) en juegos del catálogo,
  /// ignorando los que ya no existan.
  List<Game> juegosPorIds(Iterable<String> ids) {
    return ids.map(buscarPorId).whereType<Game>().toList();
  }

  void buscar(String texto) {
    _filtro = _filtro.copyWith(busqueda: texto);
    notifyListeners();
  }

  void seleccionarCategoria(String categoria) {
    _filtro = _filtro.copyWith(categoria: categoria);
    notifyListeners();
  }

  void aplicarFiltros({
    required DurationRange duracion,
    required int? jugadores,
    required Difficulty? dificultad,
  }) {
    _filtro = _filtro.copyWith(
      duracion: duracion,
      jugadores: () => jugadores,
      dificultad: () => dificultad,
    );
    notifyListeners();
  }

  void limpiarFiltros() {
    _filtro = const GameFilter();
    notifyListeners();
  }

  /// Recomendaciones para el planificador: juegos que admiten a todos los
  /// jugadores, caben en el tiempo disponible y son aptos para la edad del
  /// más pequeño. Se ordenan para que lo más fácil y corto salga primero.
  List<Game> recomendar({
    required int jugadores,
    required int minutosDisponibles,
    int? edadMenor,
    Difficulty? dificultadMaxima,
  }) {
    final resultado = _juegos.where((j) {
      final cabeEnTiempo = j.durationMinutes <= minutosDisponibles;
      final aptoPorEdad = edadMenor == null || j.minAge <= edadMenor;
      final aptoPorDificultad =
          dificultadMaxima == null ||
          j.difficulty.nivel <= dificultadMaxima.nivel;
      return j.admiteJugadores(jugadores) &&
          cabeEnTiempo &&
          aptoPorEdad &&
          aptoPorDificultad;
    }).toList();
    resultado.sort((a, b) {
      final porDificultad = a.difficulty.nivel.compareTo(b.difficulty.nivel);
      if (porDificultad != 0) return porDificultad;
      return a.durationMinutes.compareTo(b.durationMinutes);
    });
    return resultado;
  }
}
