import 'package:fpdart/fpdart.dart';

typedef FutureResult<T> = Future<Either<dynamic, T>>;


abstract class UseCase<T, Params> {
  FutureResult<T> call(Params params);
}

class NoParams {}
