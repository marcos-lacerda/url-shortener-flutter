import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';

void main() {
  Failure failureFrom(String raw) =>
      UrlToShorten.tryParse(raw).fold((l) => l, (_) =>
      throw StateError('expected failure'));

  UrlToShorten valueFrom(String raw) =>
      UrlToShorten.tryParse(raw).fold((_) =>
      throw StateError('expected success'), (r) => r);

  group('UrlToShorten.tryParse', () {
    test('normalizes www prefix', () {
      final result = valueFrom('www.example.com');
      expect(result.value.toString(), 'https://www.example.com');
    });

    test('normalizes bare domain', () {
      final result = valueFrom('example.com');
      expect(result.value.toString(), 'https://example.com');
    });

    test('fails when empty', () {
      final failure = failureFrom('');
      expect(failure, isA<ValidationFailure>());
      expect(failure.code, 'errorInvalidUrlEmpty');
    });

    test('fails when length is out of bounds', () {
      final long = 'https://${'a' * 2050}.com';
      final failure = failureFrom(long);
      expect(failure.code, 'errorInvalidUrlLength');
    });
  });
}
