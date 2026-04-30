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
      final long = 'https://example.com/?${'a' * 2050}';
      final failure = failureFrom(long);
      expect(failure.code, 'errorInvalidUrlLength');
    });

    test('fails when TLD is not a known gTLD or 2-letter ccTLD', () {
      final failure = failureFrom('www.uol');
      expect(failure, isA<ValidationFailure>());
      expect(failure.code, 'errorInvalidUrlDomain');
    });

    test('fails for single-label host even with valid scheme', () {
      final failure = failureFrom('https://localhost-ish');
      expect(failure.code, 'errorInvalidUrlDomain');
    });

    test('accepts ccTLD (2 letters)', () {
      expect(valueFrom('uol.com.br').value.host, 'uol.com.br');
      expect(valueFrom('example.de').value.host, 'example.de');
    });

    test('accepts common new-gTLDs', () {
      expect(valueFrom('myapp.dev').value.host, 'myapp.dev');
      expect(valueFrom('hello.io').value.host, 'hello.io');
    });

    test('rejects domain with consecutive dots or trailing hyphen', () {
      expect(failureFrom('foo..com').code, 'errorInvalidUrlDomain');
      expect(failureFrom('foo-.com').code, 'errorInvalidUrlDomain');
    });
  });
}
