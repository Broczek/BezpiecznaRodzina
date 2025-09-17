import 'dart:convert';
import 'package:dio/dio.dart';

// This interceptor catches outgoing HTTP requests and returns mock data
// instead of hitting a real server.
class MockApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('--> ${options.method.toUpperCase()} ${options.path}');

    final response = _getResponseForPath(options.path);

    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 200,
        data: jsonDecode(response),
      ),
      true, // Marks the response as fake to avoid real network call
    );
  }

  String _getResponseForPath(String path) {
    // Mock responses based on the request path
    switch (path) {
      case '/api/user/permissions':
        return '''
        {
          "role": "Admin"
        }
        ''';
      case '/api/devices':
        return '''
        [
          {"id": "dev1", "type": "Rodzinne SOS", "name": "Anna - córka"},
          {"id": "dev2", "type": "GJD.13", "name": "Tomek - syn"},
          {"id": "dev3", "type": "BS.07", "name": "Babcia - senior"}
        ]
        ''';
      case '/api/zones':
        return '''
        [
          {
            "id": "zone1",
            "name": "Dom",
            "address": "ul. Przykładowa 1",
            "devicesInfo": "1 telefon, 1 zegarek"
          },
          {
            "id": "zone2",
            "name": "Szkoła",
            "address": "ul. Szkolna 15",
            "devicesInfo": "1 zegarek"
          }
        ]
        ''';
      default:
        return '{}'; // Return empty object for unhandled paths
    }
  }
}
