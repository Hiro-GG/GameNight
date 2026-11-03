import 'package:flutter/material.dart';

import '../theme/core_theme.dart';

class SectionTitle extends StatelessWidget {
  final String texto;
  final String? textoAccion;
  final VoidCallback? onAccion;

  const SectionTitle({
    super.key,
    required this.texto,
    this.textoAccion,
    this.onAccion,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(texto, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (textoAccion != null)
          TextButton(
            onPressed: onAccion,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primario,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(textoAccion!),
          ),
      ],
    );
  }
}
