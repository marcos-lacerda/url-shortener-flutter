/// Representa falhas genéricas e transversais do sistema.
/// Failures específicas (ex.: InvalidUrlFailure) devem estender esta classe
/// dentro do domínio de cada feature.
abstract class Failure {
  const Failure(this.code, {this.error, this.trace});
  final String code;

  final Object? error;

  final StackTrace? trace;

  @override
  String toString() => '$runtimeType($code)';
}

/// Erro de validação de entrada — geralmente causado por dados incorretos
/// fornecidos pelo usuário ou por value objects inválidos.
class ValidationFailure extends Failure {
  const ValidationFailure(super.code);
}

/// Falha de rede (sem conexão, DNS, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure(super.code);
}

/// Erro retornado pelo servidor (5xx, 4xx não mapeado)
class ServerFailure extends Failure {
  const ServerFailure(super.code);
}

/// Timeout (requisição demorou demais)
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.code);
}

/// Falha inesperada ou não categorizada.
/// Pode ser usada como fallback para exceções não mapeadas.
class UnknownFailure extends Failure {
  const UnknownFailure([super.code = 'errorUnexpected']);
}
