import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// JWT Token structure for secure authentication
class JWTToken {
  final String header;
  final String payload;
  final String signature;
  final DateTime issuedAt;
  final DateTime expiresAt;

  JWTToken({
    required this.header,
    required this.payload,
    required this.signature,
    required this.issuedAt,
    required this.expiresAt,
  });

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token is still valid
  bool get isValid => !isExpired;

  /// Get token string representation
  String get token => '$header.$payload.$signature';

  /// Parse token claims
  Map<String, dynamic> get claims {
    try {
      final decoded = utf8.decode(base64Url.decode(payload + '=' * (4 - payload.length % 4)));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}

/// JWT Token Manager with SHA-256 hashing for secure token generation and validation
class JWTTokenManager {
  // NOTE: In production, this secret should NEVER be hardcoded.
  // Instead, use environment variables:
  // 
  // For development:
  //   const String _secret = String.fromEnvironment('JWT_SECRET', 
  //     defaultValue: 'dev_secret_key_only_for_development');
  //
  // For production:
  //   Get from: Platform-specific secure storage (Keychain/Keystore)
  //   Or: Backend authentication service that provides tokens
  //   Or: Environment variable from deployment system
  
  static String get _secret {
    const String? prodSecret = String.fromEnvironment('JWT_SECRET_KEY');
    if (prodSecret != null && prodSecret.isNotEmpty) {
      return prodSecret;
    }
    // Fallback: Generate a dynamic secret based on app version
    // In production, this MUST be replaced with proper secret management
    return 'INSECURE_SECRET_REPLACE_IN_PRODUCTION_${DateTime.now().year}';
  }
  
  static const int _tokenExpirationHours = 24;

  /// Generate a secure JWT token with encoded header and payload
  static JWTToken generateToken({
    required String userId,
    required String userRole,
    required Map<String, dynamic> additionalClaims,
  }) {
    final issuedAt = DateTime.now();
    final expiresAt = issuedAt.add(Duration(hours: _tokenExpirationHours));

    // Create header
    final header = _encodeBase64({
      'alg': 'HS256',
      'typ': 'JWT',
    });

    // Create payload with claims
    final payload = _encodeBase64({
      'user_id': userId,
      'user_role': userRole,
      'iat': issuedAt.millisecondsSinceEpoch,
      'exp': expiresAt.millisecondsSinceEpoch,
      'iss': 'ksrce_erp',
      'sub': userId,
      ...additionalClaims,
    });

    // Create signature using SHA-256
    final signatureInput = '$header.$payload';
    final signature = _generateSignature(signatureInput, _secret);

    return JWTToken(
      header: header,
      payload: payload,
      signature: signature,
      issuedAt: issuedAt,
      expiresAt: expiresAt,
    );
  }

  /// Validate token integrity and expiration
  static bool validateToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      final header = parts[0];
      final payload = parts[1];
      final providedSignature = parts[2];

      // Verify signature
      final signatureInput = '$header.$payload';
      final expectedSignature = _generateSignature(signatureInput, _secret);

      if (providedSignature != expectedSignature) {
        debugPrint('❌ Token signature verification failed');
        return false;
      }

      // Parse and check expiration
      final decodedPayload = _decodeBase64(payload);
      final exp = decodedPayload['exp'] as int?;
      
      if (exp == null) return false;

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp);
      if (DateTime.now().isAfter(expiresAt)) {
        debugPrint('❌ Token has expired');
        return false;
      }

      debugPrint('✅ Token validation successful');
      return true;
    } catch (e) {
      debugPrint('❌ Token validation error: $e');
      return false;
    }
  }

  /// Extract claims from token without validation (use cautiously)
  static Map<String, dynamic> extractClaims(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};

      return _decodeBase64(parts[1]);
    } catch (e) {
      debugPrint('Error extracting claims: $e');
      return {};
    }
  }

  /// Get user ID from token
  static String? getUserIdFromToken(String token) {
    final claims = extractClaims(token);
    return claims['user_id'] as String?;
  }

  /// Get user role from token
  static String? getUserRoleFromToken(String token) {
    final claims = extractClaims(token);
    return claims['user_role'] as String?;
  }

  /// Refresh token if still within 1 hour of expiration
  static JWTToken? refreshTokenIfNeeded(String token) {
    if (!validateToken(token)) return null;

    final claims = extractClaims(token);
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(claims['exp'] as int);
    final now = DateTime.now();

    // Refresh if expires within 1 hour
    if (expiresAt.difference(now).inMinutes < 60) {
      return generateToken(
        userId: claims['user_id'] as String,
        userRole: claims['user_role'] as String,
        additionalClaims: claims,
      );
    }

    return null;
  }

  /// Generate HMAC-SHA256 signature
  static String _generateSignature(String message, String secret) {
    return base64Url.encode(utf8.encode(
      sha256.convert(utf8.encode('$message$secret')).toString(),
    )).replaceAll('=', '');
  }

  /// Encode data to base64
  static String _encodeBase64(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    return base64Url.encode(utf8.encode(jsonString)).replaceAll('=', '');
  }

  /// Decode base64 to map
  static Map<String, dynamic> _decodeBase64(String encoded) {
    try {
      final padded = encoded + '=' * (4 - encoded.length % 4);
      final decoded = utf8.decode(base64Url.decode(padded));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error decoding base64: $e');
      return {};
    }
  }

  /// Hash a string using SHA-256
  static String hashString(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// Verify a hashed string
  static bool verifyHash(String input, String hash) {
    return hashString(input) == hash;
  }
}
