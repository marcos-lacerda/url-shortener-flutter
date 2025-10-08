// Minimal Either<Result> para evitar exceções cruzando camadas.
// Uso: Either<Failure, T> onde Left = Failure, Right = Sucesso (T).
sealed class Either<L, R> {
  const Either();
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn);

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L? get leftOrNull => this is Left<L, R> ? (this as Left<L, R>).value : null;
  R? get rightOrNull =>
      this is Right<L, R> ? (this as Right<L, R>).value : null;
}

final class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;
  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) => leftFn(value);
}

final class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;
  @override
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) => rightFn(value);
}
