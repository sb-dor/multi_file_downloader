import 'package:flutter/foundation.dart';

/// Base class for all [RestClient] exceptions
@immutable
sealed class RestClientException implements Exception {
  // message of the exception
  final String message;

  // status code of the exception
  final int? statusCode;

  // if the exception is not caused by another exception, this field is `null`
  final Object? cause;

  const RestClientException({required this.message, this.statusCode, this.cause});
}

/// [ClientException] is thrown if something went wrong on client side
/// maybe json was not encoded properly, maybe some url endpoints are not configured properly,
/// all that stuff that happens in client side
final class ClientException extends RestClientException {
  const ClientException({required super.message, super.statusCode, super.cause});

  @override
  String toString() =>
      'ClientException('
      'message: $message, '
      'statusCode: $statusCode, '
      'cause: $cause'
      ')';
}

/// if nothing happened in server but server is returning error
/// maybe something went wrong, maybe code was thrown by try-catch in server,
/// this exception for handling structured server error
/// you can use this while the data like
/// ```json
/// {
///  "error": {
///   "message": "Some error message",
///   "code": 123
/// }
/// ```
///
/// or even maybe your own error data which is coming from server
///
/// ```json
/// {
///  "success": false,
///  "message": "Some error message",
/// }
///
/// ```
final class StructuredBackendException extends RestClientException {
  /// The error returned by the backend
  final Map<String, Object?> error;

  const StructuredBackendException({required this.error, super.statusCode, super.cause})
    : super(message: 'Backend returned structured error');

  @override
  String toString() =>
      'StructuredBackendException('
      'message: $message, '
      'error: $error, '
      'statusCode: $statusCode, '
      ')';
}

/// [WrongResponseTypeException] is thrown if the response type
/// is not the expected one
final class WrongResponseTypeException extends RestClientException {
  const WrongResponseTypeException({required super.message, super.statusCode, super.cause});

  @override
  String toString() =>
      'WrongResponseTypeException('
      'message: $message, '
      'statusCode: $statusCode, '
      ')';
}

/// [ConnectionException] is thrown if there are problems with the connection
final class ConnectionException extends RestClientException {
  const ConnectionException({required super.message, super.statusCode, super.cause});

  @override
  String toString() =>
      'ConnectionException('
      'message: $message, '
      'statusCode: $statusCode, '
      'cause: $cause'
      ')';
}

/// If something went wrong on the server side
final class InternalServerException extends RestClientException {
  const InternalServerException({required super.message, super.statusCode, super.cause});

  @override
  String toString() =>
      'InternalServerException('
      'message: $message, '
      'statusCode: $statusCode, '
      'cause: $cause'
      ')';
}
