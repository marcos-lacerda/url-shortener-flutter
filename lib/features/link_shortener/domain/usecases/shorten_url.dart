import 'package:injectable/injectable.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/domain/repositories/alias_repository.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';

/// Caso de uso responsável por encurtar uma URL.
@injectable
class ShortenUrl {
  const ShortenUrl(this.repository);
  final IAliasRepository repository;

  Future<Either<Failure, ShortLink>> call(UrlToShorten url) {
    return repository.shortenURL(url: url);
  }
}
