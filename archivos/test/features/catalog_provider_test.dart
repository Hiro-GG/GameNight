import 'package:flutter_test/flutter_test.dart';
import 'package:gamenight/features/catalog/catalog_provider.dart';
import 'package:gamenight/models/game_filter.dart';
import 'package:gamenight/models/game_model.dart';

import '../helpers/game_fakes.dart';

void main() {
  late CatalogProvider provider;

  setUp(() async {
    provider = CatalogProvider(FakeGameRepository(juegosDePrueba));
    await provider.cargarJuegos();
  });

  test('carga los juegos y arma las categorías', () {
    expect(provider.juegos, hasLength(4));
    expect(provider.cargando, isFalse);
    expect(provider.categorias, [
      GameFilter.todas,
      'Cartas',
      'Estrategia',
      'Party',
    ]);
  });

  test('reporta un error si el repositorio falla', () async {
    final conError = CatalogProvider(
      FakeGameRepository(const [], fallar: true),
    );
    await conError.cargarJuegos();
    expect(conError.error, isNotNull);
    expect(conError.juegos, isEmpty);
  });

  test('búsqueda, categoría y limpiar filtros', () {
    provider.buscar('cat');
    expect(provider.juegosFiltrados.map((j) => j.id), ['catan']);

    provider.buscar('');
    provider.seleccionarCategoria('Party');
    expect(provider.juegosFiltrados.map((j) => j.id), ['codenames']);

    provider.limpiarFiltros();
    expect(provider.juegosFiltrados, hasLength(4));
  });

  test('aplicarFiltros notifica a los oyentes', () {
    var notificaciones = 0;
    provider.addListener(() => notificaciones++);
    provider.aplicarFiltros(
      duracion: DurationRange.cualquiera,
      jugadores: 4,
      dificultad: null,
    );
    expect(notificaciones, 1);
    expect(provider.juegosFiltrados.map((j) => j.id), [
      'uno',
      'catan',
      'codenames',
      'mars',
    ]);
  });

  test('recomendar respeta jugadores, tiempo, edad y dificultad', () {
    final paraSeis = provider.recomendar(jugadores: 6, minutosDisponibles: 60);
    expect(paraSeis.map((j) => j.id), ['codenames', 'uno']);

    final conNinos = provider.recomendar(
      jugadores: 4,
      minutosDisponibles: 200,
      edadMenor: 10,
    );
    expect(conNinos.map((j) => j.id), ['uno', 'catan']);

    final soloFaciles = provider.recomendar(
      jugadores: 4,
      minutosDisponibles: 200,
      dificultadMaxima: Difficulty.facil,
    );
    expect(soloFaciles.every((j) => j.difficulty == Difficulty.facil), isTrue);
  });

  test('juegosPorIds ignora ids que no existen', () {
    expect(provider.juegosPorIds(['uno', 'no-existe']).map((j) => j.id), [
      'uno',
    ]);
  });
}
