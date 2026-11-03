import 'package:gamenight/data/repositories/game_repository.dart';
import 'package:gamenight/models/game_model.dart';

Game juegoDePrueba({
  String id = 'demo',
  String name = 'Demo',
  String category = 'Party',
  int minPlayers = 2,
  int maxPlayers = 6,
  int durationMinutes = 30,
  Difficulty difficulty = Difficulty.facil,
  int minAge = 8,
}) {
  return Game(
    id: id,
    name: name,
    shortDescription: 'Descripción corta',
    description: 'Descripción larga',
    category: category,
    minPlayers: minPlayers,
    maxPlayers: maxPlayers,
    durationMinutes: durationMinutes,
    difficulty: difficulty,
    minAge: minAge,
    imgPath: 'assets/images/games/uno.png',
    rules: const ['Regla 1', 'Regla 2'],
  );
}

final juegosDePrueba = [
  juegoDePrueba(id: 'uno', name: 'UNO', category: 'Cartas', maxPlayers: 10),
  juegoDePrueba(
    id: 'catan',
    name: 'Catan',
    category: 'Estrategia',
    minPlayers: 3,
    maxPlayers: 4,
    durationMinutes: 75,
    difficulty: Difficulty.media,
    minAge: 10,
  ),
  juegoDePrueba(
    id: 'codenames',
    name: 'Código Secreto',
    category: 'Party',
    minPlayers: 4,
    maxPlayers: 8,
    durationMinutes: 15,
    minAge: 12,
  ),
  juegoDePrueba(
    id: 'mars',
    name: 'Terraforming Mars',
    category: 'Estrategia',
    minPlayers: 1,
    maxPlayers: 5,
    durationMinutes: 120,
    difficulty: Difficulty.dificil,
    minAge: 12,
  ),
];

class FakeGameRepository implements GameRepository {
  final List<Game> juegos;
  final bool fallar;
  FakeGameRepository(this.juegos, {this.fallar = false});

  @override
  Future<List<Game>> obtenerJuegos() async {
    if (fallar) throw Exception('sin datos');
    return juegos;
  }
}
