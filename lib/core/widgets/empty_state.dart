import 'package:flutter/material.dart';

import '../theme/core_theme.dart';

/// Mensaje para listas vacías o búsquedas sin resultados, con acción opcional.
class EmptyState extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String mensaje;
  final String? textoAccion;
  final VoidCallback? onAccion;

  const EmptyState({
    super.key,
    required this.icono,
    required this.titulo,
    required this.mensaje,
    this.textoAccion,
    this.onAccion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primarioClaro,
                shape: BoxShape.circle,
              ),
              child: Icon(icono, size: 36, color: AppColors.primario),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs + 2),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (textoAccion != null && onAccion != null) ...[
              const SizedBox(height: AppSpacing.md),
              TextButton(onPressed: onAccion, child: Text(textoAccion!)),
            ],
          ],
        ),
      ),
    );
  }
}
