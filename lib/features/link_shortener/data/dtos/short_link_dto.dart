import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/alias.dart';

/// DTO responsável por converter o payload JSON da API em [ShortLink].
/// Exemplo de payload:
/// {
///   "alias": "1985408273",
///   "_links": {
///     "self": "https://ge.globo.com/rs/futebol/brasileirao-serie-a/jogo/04-10-2025/internacional-botafogo.ghtml",
///     "short": "https://url-shortener-server.onrender.com/api/alias/1985408273"
///   }
/// }
class ShortLinkDto {
  const ShortLinkDto({
    required this.alias,
    required this.originalUrl,
    required this.shortUrl,
  });

  /// Cria o DTO a partir de um JSON da API ou retorna null se o payload
  /// não tiver os campos obrigatórios (`alias`, `_links.self`, `_links.short`).
  static ShortLinkDto? tryFromJson(Map<String, dynamic> json) {
    final alias = json['alias'] as String?;
    final links = json['_links'] as Map<String, dynamic>?;
    final originalUrl = links?['self'] as String?;
    final shortUrl = links?['short'] as String?;

    if (alias == null ||
        alias.isEmpty ||
        originalUrl == null ||
        originalUrl.isEmpty ||
        shortUrl == null ||
        shortUrl.isEmpty) {
      return null;
    }

    return ShortLinkDto(
      alias: alias,
      originalUrl: originalUrl,
      shortUrl: shortUrl,
    );
  }

  final String alias;
  final String originalUrl;
  final String shortUrl;

  /// Converte este DTO para a entidade de domínio [ShortLink].
  ShortLink toDomain() {
    return ShortLink(
      alias: Alias.tryParse(alias),
      original: Uri.parse(originalUrl),
      short: Uri.parse(shortUrl),
    );
  }
}
