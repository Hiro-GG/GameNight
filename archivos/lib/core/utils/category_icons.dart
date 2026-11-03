import 'package:flutter/material.dart';

IconData iconoCategoria(String categoria) {
  switch (categoria) {
    case 'Estrategia':
      return Icons.psychology_outlined;
    case 'Familiar':
      return Icons.family_restroom_outlined;
    case 'Party':
      return Icons.celebration_outlined;
    case 'Cartas':
      return Icons.style_outlined;
    case 'Cooperativo':
      return Icons.handshake_outlined;
    case 'Habilidad':
      return Icons.back_hand_outlined;
    default:
      return Icons.casino_outlined;
  }
}
