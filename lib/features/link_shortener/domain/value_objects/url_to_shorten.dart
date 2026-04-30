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

    // 3) Domínio plausível: estrutura `label(.label)+.tld` e TLD válido.
    if (!_hasValidDomainStructure(uri.host) || !_hasKnownTld(uri.host)) {
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

  /// Verifica se o host tem estrutura mínima de domínio: pelo menos
  /// dois labels separados por ponto, cada um começando/terminando com
  /// alfanumérico, sem pontos consecutivos, sem hífen no início/fim.
  static final _domainStructure = RegExp(
    r'^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,24}$',
  );

  static bool _hasValidDomainStructure(String host) =>
      _domainStructure.hasMatch(host);

  /// TLDs aceitos: qualquer ccTLD de 2 letras (ISO 3166-1 alpha-2 cobre
  /// todos os países) + whitelist enxuta de gTLDs / new-gTLDs comuns.
  static const _knownGtlds = <String>{
    // gTLDs originais e patrocinados
    'com', 'org', 'net', 'edu', 'gov', 'mil', 'int',
    'info', 'biz', 'name', 'pro', 'mobi', 'asia', 'tel',
    // new-gTLDs populares
    'io', 'dev', 'app', 'ai', 'co', 'me', 'tv', 'fm', 'cc',
    'xyz', 'online', 'tech', 'cloud', 'site', 'store', 'shop',
    'blog', 'art', 'inc', 'ltd', 'live', 'news', 'one', 'world',
    'design', 'studio', 'agency', 'digital', 'media', 'video',
    'global', 'group', 'page', 'link', 'click',
  };

  static bool _hasKnownTld(String host) {
    final tld = host.split('.').last.toLowerCase();
    if (tld.length == 2) return true; // ccTLD (br, us, uk, de, ...)
    return _knownGtlds.contains(tld);
  }

  @override
  String toString() => value.toString();
}
