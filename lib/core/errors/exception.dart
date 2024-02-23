import 'package:equatable/equatable.dart';

class Exception extends Equatable {
  final String message;
  final StackTrace stack;
  const Exception(this.message, {required this.stack});

  @override
  List<Object> get props => [message, stack];
}

class ServerException extends Exception {
  const ServerException(
    super.message, {
    super.stack = StackTrace.empty,
  });
}

class CacheException extends Exception {
  const CacheException(
    super.message, {
    super.stack = StackTrace.empty,
  });
}

class RequestException extends Exception {
  const RequestException(
    super.message, {
    super.stack = StackTrace.empty,
  });
}
