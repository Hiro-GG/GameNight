import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamenight/data/repositories/game_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('el JSON local es válido y sus imágenes existen', () async {
    final juegos = await LocalGameRepository().obtenerJuegos();
    expect(juegos, isNotEmpty);

    final ids = juegos.map((j) => j.id).toSet();
    expect(ids, hasLength(juegos.length), reason: 'ids repetidos');

    for (final juego in juegos) {
      expect(juego.minPlayers, lessThanOrEqualTo(juego.maxPlayers));
      expect(juego.rules, isNotEmpty, reason: juego.id);
      // Falla si la portada no está declarada en pubspec.yaml.
      await rootBundle.load(juego.imgPath);
    }
  });
}
