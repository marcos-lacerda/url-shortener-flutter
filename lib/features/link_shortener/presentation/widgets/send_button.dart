import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
    this.elevation = 2,
  });

  /// Ícone exibido no centro (ex: [Icons.arrow_forward_ios])
  final IconData icon;

  /// Callback acionado no toque
  final VoidCallback? onPressed;

  /// Tamanho total do botão (largura = altura)
  final double size;

  /// Cor de fundo (se nula, usa colorScheme.surfaceVariant)
  final Color? backgroundColor;

  /// Cor do ícone (se nula, usa colorScheme.onSurface)
  final Color? iconColor;

  /// Elevação do botão (sombra leve)
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      elevation: elevation,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: iconColor ?? theme.colorScheme.onSurface,
            size: size * 0.45,
          ),
        ),
      ),
    );
  }
}
