import 'package:flutter/material.dart';

/// Botón principal de la app. `secundario` lo dibuja con contorno, para
/// acciones de menor peso al lado de la principal.
class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool secundario;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.secundario = false,
  });

  @override
  Widget build(BuildContext context) {
    if (secundario) {
      return icon != null
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(text),
            )
          : OutlinedButton(onPressed: onPressed, child: Text(text));
    }
    return icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 20),
            label: Text(text),
          )
        : ElevatedButton(onPressed: onPressed, child: Text(text));
  }
}
