import 'package:flutter/material.dart';
import 'package:url_shortener/core/theme/app_spacing.dart';

class AppList<T> extends StatelessWidget {
  const AppList({
    required this.title,
    required this.items,
    required this.itemBuilder,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.separatorHeight = 8,
  });

  /// Título exibido acima da lista.
  final String title;

  /// Lista de itens genérica.
  final List<T> items;

  /// Builder para renderizar cada item.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Espaçamento interno.
  final EdgeInsets padding;

  /// Espaço entre os itens.
  final double separatorHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Column(
        spacing: AppSpacing.sm,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Flexible(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => SizedBox(height: separatorHeight),
              itemBuilder: (context, index) =>
                  itemBuilder(context, items[index]),
            ),
          ),
        ],
      ),
    );
  }
}
