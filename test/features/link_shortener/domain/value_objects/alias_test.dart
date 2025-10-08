import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/alias.dart';

void main() {
  group('Alias.tryParse', () {
    test('returns Alias when input has only digits', () {
      final alias = Alias.tryParse('  12345 ');
      expect(alias, isNotNull);
      expect(alias!.value, '12345');
    });

    test('returns null when input is empty', () {
      expect(Alias.tryParse('   '), isNull);
    });

    test('returns null when input has non-digit chars', () {
      expect(Alias.tryParse('12ab34'), isNull);
    });
  });
}
