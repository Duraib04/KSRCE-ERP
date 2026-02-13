/// API Exception Classes

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? response;
  final Exception? originalException;

  ApiException({
    required this.message,
    this.statusCode,
    this.response,
    this.originalException,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class AuthenticationException extends ApiException {
  AuthenticationException({
    String message = 'Authentication failed. Please login again.',
    int? statusCode,
    String? response,
    Exception? originalException,
  }) : super(
    message: message,
    statusCode: statusCode,
    response: response,
    originalException: originalException,
  );
}

class AuthorizationException extends ApiException {
  AuthorizationException({
    String message = 'You do not have permission to access this resource.',
    int? statusCode,
    String? response,
    Exception? originalException,
  }) : super(
    message: message,
    statusCode: statusCode,
    response: response,
    originalException: originalException,
  );
}

class NetworkException extends ApiException {
  NetworkException({
    String message = 'Network error. Please check your internet connection.',
    Exception? originalException,
  }) : super(
    message: message,
    originalException: originalException,
  );
}

class ServerException extends ApiException {
  ServerException({
    String message = 'Server error. Please try again later.',
    int? statusCode,
    String? response,
    Exception? originalException,
  }) : super(
    message: message,
    statusCode: statusCode,
    response: response,
    originalException: originalException,
  );
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  ValidationException({
    String message = 'Validation failed.',
    int? statusCode,
    String? response,
    this.errors,
    Exception? originalException,
  }) : super(
    message: message,
    statusCode: statusCode,
    response: response,
    originalException: originalException,
  );
}

class TimeoutException extends ApiException {
  TimeoutException({
    String message = 'Request timeout. Please try again.',
    Exception? originalException,
  }) : super(
    message: message,
    originalException: originalException,
  );
}

/// API Response Models

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: fromJsonT != null && json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] as Map<String, dynamic>?,
      statusCode: json['statusCode'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data,
    'errors': errors,
    'statusCode': statusCode,
  };

  @override
  String toString() => 'ApiResponse(success: $success, message: $message, statusCode: $statusCode)';
}

class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final itemsList = json['items'] as List? ?? [];
    final items = fromJsonT != null
        ? itemsList.map((item) => fromJsonT(item)).toList()
        : itemsList.cast<T>();

    return PaginatedResponse(
      items: items,
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }
}

class AuthResponse {
  final String accessToken;
  final String? refreshToken;
  final String userId;
  final String userRole;
  final DateTime expiresAt;

  AuthResponse({
    required this.accessToken,
    this.refreshToken,
    required this.userId,
    required this.userRole,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
      userId: json['userId'] as String? ?? '',
      userRole: json['userRole'] as String? ?? '',
      expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'userId': userId,
    'userRole': userRole,
    'expiresAt': expiresAt.toIso8601String(),
  };

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isValid => !isExpired && accessToken.isNotEmpty;
}
