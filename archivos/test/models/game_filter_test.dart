import 'package:flutter_test/flutter_test.dart';
import 'package:gamenight/models/game_filter.dart';
import 'package:gamenight/models/game_model.dart';

import '../helpers/game_fakes.dart';

void main() {
  group('GameFilter', () {
    test('sin criterios acepta todos los juegos', () {
      const filtro = GameFilter();
      expect(juegosDePrueba.every(filtro.coincide), isTrue);
      expect(filtro.estaVacio, isTrue);
    });

    test('la búsqueda ignora mayúsculas y acentos', () {
      const filtro = GameFilter(busqueda: 'codigo');
      final resultado = juegosDePrueba.where(filtro.coincide).toList();
      expect(resultado.map((j) => j.id), ['codenames']);
    });

    test('filtra por categoría, jugadores, duración y dificultad', () {
      const porCategoria = GameFilter(categoria: 'Estrategia');
      expect(juegosDePrueba.where(porCategoria.coincide).map((j) => j.id), [
        'catan',
        'mars',
      ]);

      const porJugadores = GameFilter(jugadores: 9);
      expect(juegosDePrueba.where(porJugadores.coincide).map((j) => j.id), [
        'uno',
      ]);

      const porDuracion = GameFilter(duracion: DurationRange.larga);
      expect(juegosDePrueba.where(porDuracion.coincide).map((j) => j.id), [
        'catan',
        'mars',
      ]);

      const porDificultad = GameFilter(dificultad: Difficulty.dificil);
      expect(juegosDePrueba.where(porDificultad.coincide).map((j) => j.id), [
        'mars',
      ]);
    });

    test('copyWith puede quitar un filtro opcional', () {
      const filtro = GameFilter(jugadores: 4, dificultad: Difficulty.media);
      expect(filtro.filtrosActivos, 2);
      final sinJugadores = filtro.copyWith(jugadores: () => null);
      expect(sinJugadores.jugadores, isNull);
      expect(sinJugadores.dificultad, Difficulty.media);
      expect(sinJugadores.filtrosActivos, 1);
    });
  });

  group('Game', () {
    test('fromJson y toJson son simétricos', () {
      final juego = juegoDePrueba(id: 'x', difficulty: Difficulty.dificil);
      final copia = Game.fromJson(juego.toJson());
      expect(copia.toJson(), juego.toJson());
    });

    test('textos de jugadores', () {
      expect(juegoDePrueba(minPlayers: 2, maxPlayers: 6).jugadoresTexto, '2–6');
      expect(juegoDePrueba(minPlayers: 4, maxPlayers: 4).jugadoresTexto, '4');
    });
  });
}
