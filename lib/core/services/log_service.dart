import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LogService {
  const LogService();

  void info(String message, {String? tag}) {
    _log('INFO', message, tag);
  }

  void success(String message, {String? tag}) {
    _log('SUCCESS', message, tag);
  }

  void warning(String message, {String? tag}) {
    _log('WARNING', message, tag);
  }

  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final errorMsg = error != null ? ' → $error' : '';
    _log('ERROR', '$message$errorMsg', tag);

    if (stackTrace != null && kDebugMode) {
      debugPrint(stackTrace.toString());
    }
  }

  /// Método interno responsável por formatar e imprimir o log.
  void _log(String level, String message, [String? tag]) {
    if (!kDebugMode) return; // só loga em modo debug

    final timestamp = DateTime.now().toIso8601String().split('T').join(' ');
    final formattedTag = tag != null ? '[$tag]' : '';
    debugPrint('[$timestamp] [$level] $formattedTag $message');
  }
}
