import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/features/link_shortener/data/dtos/short_link_dto.dart';

void main() {
  group('ShortLinkDto', () {
    test('fromJson maps payload to domain entity', () {
      const json = {
        'alias': '1985408273',
        '_links': {
          'self': 'https://example.com/articles/42',
          'short': 'https://url-shortener/api/alias/1985408273',
        },
      };

      final dto = ShortLinkDto.fromJson(json);
      expect(dto.alias, '1985408273');
      expect(dto.originalUrl, 'https://example.com/articles/42');
      expect(dto.shortUrl, 'https://url-shortener/api/alias/1985408273');

      final domain = dto.toDomain();
      expect(domain.alias?.value, '1985408273');
      expect(domain.original.toString(), 'https://example.com/articles/42');
      expect(
        domain.short.toString(),
        'https://url-shortener/api/alias/1985408273',
      );
    });
  });
}
