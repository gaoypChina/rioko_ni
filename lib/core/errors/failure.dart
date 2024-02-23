import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final StackTrace stack;
  const Failure(
    this.message, {
    required this.stack,
  });

  String get fullMessage => '$message \n$stack';

  @override
  List<Object> get props => [message];
}

class RequestFailure extends Failure {
  const RequestFailure(
    super.message, {
    super.stack = StackTrace.empty,
  });
}

class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    super.stack = StackTrace.empty,
  });
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(
    super.message, {
    super.stack = StackTrace.empty,
  });
}

class CacheFailure extends Failure {
  const CacheFailure(
    super.message, {
    super.stack = StackTrace.empty,
  });
}

class RepositoryFailure extends Failure {
  const RepositoryFailure(
    super.message, {
    super.stack = StackTrace.empty,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure(
    super.message, {
    super.stack = StackTrace.empty,
  });
}
