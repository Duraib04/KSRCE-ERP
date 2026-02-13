import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../config/api_config.dart';
import 'api_exceptions.dart';

/// HTTP Client Service for API Communication
/// This service handles all HTTP requests to the backend API
class HttpClientService {
  late http.Client _httpClient;
  String _authToken = '';

  HttpClientService() {
    _httpClient = http.Client();
  }

  /// Set authentication token for subsequent requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear authentication token
  void clearAuthToken() {
    _authToken = '';
  }

  /// Build headers for API requests
  Map<String, String> _buildHeaders({bool includeAuth = true}) {
    final headers = <String, String>{
      'Content-Type': ApiHeaders.contentType,
      'Accept': ApiHeaders.contentType,
    };

    if (includeAuth && _authToken.isNotEmpty) {
      headers[ApiHeaders.authorization] = '${ApiHeaders.bearerPrefix} $_authToken';
    }

    return headers;
  }

  /// Perform GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = _buildHeaders(includeAuth: requiresAuth);

      final response = await _httpClient
          .get(uri, headers: headers)
          .timeout(ApiConfig.connectionTimeout, onTimeout: () {
        throw TimeoutException();
      });

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Perform POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = _buildHeaders(includeAuth: requiresAuth);
      final encodedBody = body != null ? jsonEncode(body) : null;

      final response = await _httpClient
          .post(uri, headers: headers, body: encodedBody)
          .timeout(ApiConfig.connectionTimeout, onTimeout: () {
        throw TimeoutException();
      });

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Perform PUT request
  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = _buildHeaders(includeAuth: requiresAuth);
      final encodedBody = body != null ? jsonEncode(body) : null;

      final response = await _httpClient
          .put(uri, headers: headers, body: encodedBody)
          .timeout(ApiConfig.connectionTimeout, onTimeout: () {
        throw TimeoutException();
      });

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Perform DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = _buildHeaders(includeAuth: requiresAuth);

      final response = await _httpClient
          .delete(uri, headers: headers)
          .timeout(ApiConfig.connectionTimeout, onTimeout: () {
        throw TimeoutException();
      });

      return _handleResponse(response);
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Build full URI from endpoint and query parameters
  Uri _buildUri(String endpoint, Map<String, String>? queryParams) {
    final url = '${ApiConfig.baseUrl}$endpoint';
    return Uri.parse(url).replace(queryParameters: queryParams);
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    try {
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == ApiStatusCode.success ||
          response.statusCode == ApiStatusCode.created) {
        return decodedResponse;
      } else if (response.statusCode == ApiStatusCode.unauthorized) {
        throw AuthenticationException(
          statusCode: response.statusCode,
          response: response.body,
        );
      } else if (response.statusCode == ApiStatusCode.forbidden) {
        throw AuthorizationException(
          statusCode: response.statusCode,
          response: response.body,
        );
      } else if (response.statusCode == ApiStatusCode.badRequest) {
        final errors = decodedResponse['errors'] as Map<String, dynamic>?;
        throw ValidationException(
          message: decodedResponse['message'] ?? 'Validation failed',
          statusCode: response.statusCode,
          response: response.body,
          errors: errors,
        );
      } else if (response.statusCode >= ApiStatusCode.serverError) {
        throw ServerException(
          message: decodedResponse['message'] ?? 'Server error occurred',
          statusCode: response.statusCode,
          response: response.body,
        );
      } else {
        throw ApiException(
          message: decodedResponse['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
          response: response.body,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Failed to parse response',
        response: response.body,
        originalException: e as Exception,
      );
    }
  }

  /// Handle errors
  void _handleError(dynamic error) {
    if (error is ApiException) {
      throw error;
    } else if (error is TimeoutException) {
      throw TimeoutException();
    } else {
      throw NetworkException(
        originalException: error is Exception ? error : Exception(error.toString()),
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
