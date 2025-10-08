import 'package:url_shortener/core/result/either.dart';

Either<L, R> left<L, R>(L l) => Left<L, R>(l);
Either<L, R> right<L, R>(R r) => Right<L, R>(r);

extension EitherUnpack<L, R> on Either<L, R> {
  (L?, R?) unpack() => fold((l) => (l, null), (r) => (null, r));
}
