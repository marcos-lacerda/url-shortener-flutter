import 'package:flutter/material.dart';
import 'package:url_shortener/core/theme/app_spacing.dart';

/// Componente visual para exibição de mensagens de erro.
class AppErrorMessage extends StatelessWidget {
  const AppErrorMessage({
    required this.message,
    super.key,
    this.onClose,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 8,
  });

  /// Mensagem de erro exibida.
  final String message;

  /// Ação executada ao clicar no ícone de fechar (opcional).
  final VoidCallback? onClose;

  /// Espaçamento interno do container.
  final EdgeInsets padding;

  /// Raio de arredondamento do contêiner.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = theme.colorScheme.error;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Icon(Icons.error_outline, color: color, size: 20),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
          if (onClose != null)
            IconButton(
              key: const Key('error_close_button'),
              icon: Icon(Icons.close, color: color, size: 16),
              onPressed: onClose,
              splashRadius: 16,
            ),
        ],
      ),
    );
  }
}
