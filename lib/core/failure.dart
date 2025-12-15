abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache error occurred"]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
