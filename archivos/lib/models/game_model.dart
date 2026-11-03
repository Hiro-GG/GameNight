enum Difficulty {
  facil('Fácil', 1),
  media('Media', 2),
  dificil('Difícil', 3);

  final String label;
  final int nivel;
  const Difficulty(this.label, this.nivel);

  static Difficulty fromString(String valor) {
    return Difficulty.values.firstWhere(
      (d) => d.name == valor,
      orElse: () => Difficulty.media,
    );
  }
}

class Game {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final String category;
  final int minPlayers;
  final int maxPlayers;
  final int durationMinutes;
  final Difficulty difficulty;
  final int minAge;
  final String imgPath;
  final List<String> rules;

  const Game({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.category,
    required this.minPlayers,
    required this.maxPlayers,
    required this.durationMinutes,
    required this.difficulty,
    required this.minAge,
    required this.imgPath,
    required this.rules,
  });

  // El mismo formato sirve para el JSON local (Etapa 1) y para un documento
  // de Firestore (Etapa 2), así el Repository es lo único que cambia.
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      minPlayers: json['minPlayers'] as int,
      maxPlayers: json['maxPlayers'] as int,
      durationMinutes: json['durationMinutes'] as int,
      difficulty: Difficulty.fromString(json['difficulty'] as String),
      minAge: json['minAge'] as int,
      imgPath: json['imgPath'] as String,
      rules: List<String>.from(json['rules'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortDescription': shortDescription,
      'description': description,
      'category': category,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'durationMinutes': durationMinutes,
      'difficulty': difficulty.name,
      'minAge': minAge,
      'imgPath': imgPath,
      'rules': rules,
    };
  }

  bool admiteJugadores(int jugadores) =>
      jugadores >= minPlayers && jugadores <= maxPlayers;

  String get jugadoresTexto =>
      minPlayers == maxPlayers ? '$minPlayers' : '$minPlayers–$maxPlayers';

  String get duracionTexto => '$durationMinutes min';

  String get edadTexto => '$minAge+';
}
