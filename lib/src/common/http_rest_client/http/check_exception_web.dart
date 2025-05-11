import 'package:flutter_multi_file_downloader/src/common/http_rest_client/http_exceptions/rest_client_exception.dart';
import 'package:http/http.dart' as http;

/// Checks the [http.ClientException] and tries to parse it.
Object? checkHttpException(http.ClientException e) {
  if (e.message.contains('XMLHttpRequest error')) {
    return ConnectionException(message: e.message, cause: e);
  }

  return null;
}
