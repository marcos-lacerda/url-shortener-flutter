import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/alias.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';

abstract class IAliasRepository {
  Future<Either<Failure, ShortLink>> shortenURL({required UrlToShorten url});

  Future<Either<Failure, Uri>> getAlias({required Alias alias});
}
