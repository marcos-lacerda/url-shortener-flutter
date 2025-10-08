import 'package:equatable/equatable.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';

sealed class LinkShortenerState extends Equatable {
  const LinkShortenerState({this.items = const []});
  final List<ShortLink> items;

  @override
  List<Object?> get props => [items];
}

final class LinkShortenerIdle extends LinkShortenerState {
  const LinkShortenerIdle({super.items = const []});
}

class LinkShortenerLoading extends LinkShortenerState {
  const LinkShortenerLoading({required super.items});
}

final class LinkShortenerSuccess extends LinkShortenerState {
  const LinkShortenerSuccess({required super.items});

  @override
  List<Object?> get props => [items];
}

final class LinkShortenerError extends LinkShortenerState {
  const LinkShortenerError({required super.items, required this.errorCode});
  final String errorCode;

  @override
  List<Object?> get props => [items, errorCode];
}
