import "package:flutter_multi_file_downloader/src/common/http_rest_client/http_exceptions/rest_client_exception.dart";
import 'package:flutter_multi_file_downloader/src/common/http_rest_client/rest_client_base.dart';
import "package:http/http.dart" as http;
import "package:logger/logger.dart";

import "check_exception_io.dart" if (dart.library.js_interop) "check_exception_web.dart";

final class RestClientHttp extends RestClientBase {
  RestClientHttp({
    required super.baseUrl,
    required this.logger,
    http.Client? client, // you don't have to send client, uses for tests most of all
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final Logger logger;

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required RequestType method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);

      final request = http.MultipartRequest(method.name, uri);

      // Add files to the multipart request
      // file's name will be added with it's field which you added from http.MultipartFile
      // take a look inside network/http_rest_client/repository_test.dart
      if (files != null && files.isNotEmpty) {
        request.files.addAll(files);
      }

      // Add other fields in the body to the multipart request
      if (body != null) {
        body.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      // Add headers if provided
      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await _client.send(request);

      final responseStream = await http.Response.fromStream(response);

      // Log the server's response body
      logger.log(Level.debug, "body is: ${responseStream.body}");

      return await decodeResponse(
        BytesResponseBody(responseStream.bodyBytes),
        statusCode: response.statusCode,
      );
    } on RestClientException {
      rethrow;
    } on http.ClientException catch (e, stack) {
      logger.log(Level.debug, "error is: $e");
      // TODO: write en error exception
      // write exceptions in the future
      // when you will get what is going on here
      final checkException = checkHttpException(e);

      // the Error.throwWithStackTrace method is used to rethrow an exception
      // while preserving the stack trace, which is important for debugging.
      if (checkException != null) {
        Error.throwWithStackTrace(checkException, stack);
      }

      Error.throwWithStackTrace(ClientException(message: e.message, cause: e), stack);
    }
  }

  @override
  Future<http.StreamedResponse> sendAndGetStream({
    required String path,
    required RequestType method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);

      final request = http.MultipartRequest(method.name, uri);

      // Add files to the multipart request
      // file's name will be added with it's field which you added from http.MultipartFile
      // take a look inside network/http_rest_client/repository_test.dart
      if (files != null && files.isNotEmpty) {
        request.files.addAll(files);
      }

      // Add other fields in the body to the multipart request
      if (body != null) {
        body.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      // Add headers if provided
      if (headers != null) {
        request.headers.addAll(headers);
      }

      final response = await _client.send(request);

      return response;
    } on RestClientException {
      rethrow;
    } on http.ClientException catch (e, stack) {
      logger.log(Level.debug, "error is: $e");
      // TODO: write en error exception
      // write exceptions in the future
      // when you will get what is going on here
      final checkException = checkHttpException(e);

      // the Error.throwWithStackTrace method is used to rethrow an exception
      // while preserving the stack trace, which is important for debugging.
      if (checkException != null) {
        Error.throwWithStackTrace(checkException, stack);
      }

      Error.throwWithStackTrace(ClientException(message: e.message, cause: e), stack);
    }
  }
}
