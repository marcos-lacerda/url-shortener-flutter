import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/core/result/either_extensions.dart';

/// Value Object responsável por representar e validar URLs a serem encurtadas.
class UrlToShorten {

  const UrlToShorten._(this.value);
  final Uri value;

  static Either<Failure, UrlToShorten> tryParse(String raw) {
    final input = raw.trim();
    if (input.isEmpty) {
      return left(const ValidationFailure('errorInvalidUrlEmpty'));
    }

    final normalized = _normalize(input);
    final uri = Uri.tryParse(normalized);
    if (uri == null) {
      return left(const ValidationFailure('errorInvalidUrlFormat'));
    }

    // 1) Esquema primeiro
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return left(const ValidationFailure('errorInvalidUrlScheme'));
    }

    // 2) Host obrigatório
    if (uri.host.isEmpty) {
      return left(const ValidationFailure('errorInvalidUrlHostEmpty'));
    }

    // 3) Domínio plausível (pelo menos um ponto e TLD 2–24)
    final domainPattern =
    RegExp(r'^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,24}$', caseSensitive: false);
    if (!domainPattern.hasMatch(uri.host)) {
      return left(const ValidationFailure('errorInvalidUrlDomain'));
    }

    // 4) Localhost / IPs locais
    const disallowedHosts = {'localhost', '127.0.0.1', '::1'};
    if (disallowedHosts.contains(uri.host)) {
      return left(const ValidationFailure('errorInvalidUrlLocalhost'));
    }

    // 5) Comprimento razoável
    if (normalized.length < 10 || normalized.length > 2048) {
      return left(const ValidationFailure('errorInvalidUrlLength'));
    }

    return right(UrlToShorten._(uri));
  }

  static String _normalize(String raw) {
    final t = raw.trim();
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    if (t.startsWith('www.')) return 'https://$t';
    return 'https://$t';
  }

  @override
  String toString() => value.toString();
}
