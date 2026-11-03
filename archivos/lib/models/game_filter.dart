import '../core/utils/text_utils.dart';
import 'game_model.dart';

enum DurationRange {
  cualquiera('Cualquiera', 0, 9999),
  corta('Hasta 20 min', 0, 20),
  media('20 a 45 min', 21, 45),
  larga('Más de 45 min', 46, 9999);

  final String label;
  final int min;
  final int max;
  const DurationRange(this.label, this.min, this.max);

  bool incluye(int minutos) => minutos >= min && minutos <= max;
}

/// Criterios de búsqueda del catálogo. Es inmutable: cada cambio crea un
/// filtro nuevo con [copyWith], así el Provider solo reemplaza el objeto.
class GameFilter {
  static const String todas = 'Todas';

  final String busqueda;
  final String categoria;
  final DurationRange duracion;
  final int? jugadores;
  final Difficulty? dificultad;

  const GameFilter({
    this.busqueda = '',
    this.categoria = todas,
    this.duracion = DurationRange.cualquiera,
    this.jugadores,
    this.dificultad,
  });

  GameFilter copyWith({
    String? busqueda,
    String? categoria,
    DurationRange? duracion,
    int? Function()? jugadores,
    Difficulty? Function()? dificultad,
  }) {
    return GameFilter(
      busqueda: busqueda ?? this.busqueda,
      categoria: categoria ?? this.categoria,
      duracion: duracion ?? this.duracion,
      // Se reciben como función para poder distinguir "no cambiar" de "quitar".
      jugadores: jugadores != null ? jugadores() : this.jugadores,
      dificultad: dificultad != null ? dificultad() : this.dificultad,
    );
  }

  /// Filtros de la hoja "Filtros" activos (sin contar búsqueda ni categoría).
  int get filtrosActivos {
    var total = 0;
    if (duracion != DurationRange.cualquiera) total++;
    if (jugadores != null) total++;
    if (dificultad != null) total++;
    return total;
  }

  bool get estaVacio =>
      busqueda.trim().isEmpty && categoria == todas && filtrosActivos == 0;

  bool coincide(Game juego) {
    final coincideNombre = normalizar(juego.name)
        .contains(normalizar(busqueda));
    final coincideCategoria = categoria == todas || juego.category == categoria;
    final coincideDuracion = duracion.incluye(juego.durationMinutes);
    final coincideJugadores =
        jugadores == null || juego.admiteJugadores(jugadores!);
    final coincideDificultad =
        dificultad == null || juego.difficulty == dificultad;
    return coincideNombre &&
        coincideCategoria &&
        coincideDuracion &&
        coincideJugadores &&
        coincideDificultad;
  }
}
