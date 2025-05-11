import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_multi_file_downloader/src/common/http_rest_client/rest_client.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'http_exceptions/rest_client_exception.dart';

enum RequestType { get, post, put, delete, patch }

abstract base class RestClientBase implements RestClient {
  RestClientBase({required String baseUrl}) : baseUrl = Uri.parse(baseUrl);

  final Uri baseUrl;
  final _jsonUTF8 = json.fuse(utf8);

  Future<Map<String, Object?>?> send({
    required String path,
    required RequestType method,
    Map<String, Object?>? body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  });

  @override
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) => send(path: path, method: RequestType.get, headers: headers, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  }) => send(
    path: path,
    method: RequestType.post,
    body: body,
    headers: headers,
    queryParams: queryParams,
    files: files,
  );

  @override
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    List<http.MultipartFile>? files,
  }) => send(
    path: path,
    method: RequestType.put,
    body: body,
    headers: headers,
    queryParams: queryParams,
    files: files,
  );

  @override
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) => send(path: path, method: RequestType.delete, headers: headers, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) => send(
    path: path,
    method: RequestType.patch,
    body: body,
    headers: headers,
    queryParams: queryParams,
  );

  @protected
  Uri buildUri({required String path, Map<String, String?>? queryParams}) {
    final finalPath = p.join(baseUrl.path, path);
    // Creates a new Uri based on this one, but with some parts replaced.
    // This method takes the same parameters as the Uri constructor, and they have the same meaning
    return baseUrl.replace(
      path: finalPath,
      // get original queryParameters and also sending queryParams if it exists
      queryParameters: {...baseUrl.queryParameters, ...?queryParams},
    );
  }

  @protected
  Future<Map<String, Object?>?> decodeResponse(
    ResponseBody<Object>? body, {
    int? statusCode,
  }) async {
    if (body == null) return null;
    try {
      final decodedBody = switch (body) {
        final MapResponseBody data => data.data,
        final StringResponseBody data => await _decodeString(data.data),
        final BytesResponseBody data => await _decodeBytes(data.data),
      };

      if (decodedBody case {"error": final Map<String, Object?> error}) {
        throw StructuredBackendException(error: error, statusCode: statusCode);
      }

      if (decodedBody case {"data": final Map<String, Object?> data}) {
        return data;
      }

      return decodedBody;
    } on RestClientException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ClientException(
          message: 'Error occurred during decoding',
          statusCode: statusCode,
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  Future<Map<String, Object?>?> _decodeString(String stringBody) async {
    if (stringBody.isEmpty) return null;

    // run in another isolate in order to convert string into Map
    if (stringBody.length > 1000) {
      return (await compute(
            jsonDecode,
            stringBody,
            debugLabel: kDebugMode ? "Decode String compute" : null,
          ))
          as Map<String, Object?>;
    }

    return jsonDecode(stringBody) as Map<String, Object?>;
  }

  Future<Map<String, Object?>?> _decodeBytes(List<int> bytesBody) async {
    if (bytesBody.isEmpty) return null;

    // run in another isolate in order to convert bytes into Map
    if (bytesBody.length > 1000) {
      return (await compute(
            _jsonUTF8.decode,
            bytesBody,
            debugLabel: kDebugMode ? 'Decode Bytes Compute' : null,
          ))!
          as Map<String, Object?>;
    }

    return _jsonUTF8.decode(bytesBody) as Map<String, Object?>;
  }
}

@immutable
sealed class ResponseBody<T> {
  final T data;

  const ResponseBody(this.data);
}

class StringResponseBody extends ResponseBody<String> {
  const StringResponseBody(super.data);
}

class MapResponseBody extends ResponseBody<Map<String, Object?>> {
  const MapResponseBody(super.data);
}

class BytesResponseBody extends ResponseBody<List<int>> {
  const BytesResponseBody(super.data);
}
