import 'package:equatable/equatable.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/alias.dart';

class ShortLink extends Equatable {
  const ShortLink({
    required this.original,
    required this.short,
    this.alias,
  });
  final Alias? alias;
  final Uri original;
  final Uri short;

  @override
  List<Object?> get props => [alias, original, short];
}
