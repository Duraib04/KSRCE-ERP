import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Error page displayed when a route is not found or an error occurs.
/// Uses b-block image as background.
class ErrorPage extends StatelessWidget {
  final String? error;
  final int statusCode;

  const ErrorPage({
    super.key,
    this.error,
    this.statusCode = 404,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/b-block.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error Icon
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 80,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Status Code
                  Text(
                    '$statusCode',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error Title
                  Text(
                    _getErrorTitle(statusCode),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Error Message
                  Text(
                    error ?? _getErrorMessage(statusCode),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.go('/'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home),
                          SizedBox(width: 8),
                          Text(
                            'Go Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.primary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back),
                          const SizedBox(width: 8),
                          Text(
                            'Go Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getErrorTitle(int code) {
    switch (code) {
      case 404:
        return 'Page Not Found';
      case 403:
        return 'Access Denied';
      case 500:
        return 'Server Error';
      case 503:
        return 'Service Unavailable';
      default:
        return 'Oops! An Error Occurred';
    }
  }

  String _getErrorMessage(int code) {
    switch (code) {
      case 404:
        return 'The page you are looking for does not exist or has been moved.';
      case 403:
        return 'You do not have permission to access this resource.';
      case 500:
        return 'Something went wrong on our end. Please try again later.';
      case 503:
        return 'The service is temporarily unavailable. Please try again soon.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
