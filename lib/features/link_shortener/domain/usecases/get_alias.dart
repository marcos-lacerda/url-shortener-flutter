import 'package:injectable/injectable.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/features/link_shortener/domain/repositories/alias_repository.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/alias.dart';

/// Caso de uso responsável por buscar a URL original a partir do alias.
@injectable
class GetAlias {
  const GetAlias(this._repository);

  final IAliasRepository _repository;

  Future<Either<Failure, Uri>> call(Alias alias) {
    return _repository.getAlias(alias: alias);
  }
}
