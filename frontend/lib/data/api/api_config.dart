import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base URL of the backend API.
///
/// Override at build/run time with:
///   --dart-define=API_BASE_URL=https://api.yoursite.com/api
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080/api',
);

/// Shared Dio HTTP client.
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));
});

/// Turns an API/network error into a user-friendly message.
String apiErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map) {
      final fields = data['fields'];
      if (fields is Map && fields.isNotEmpty) {
        return fields.values.first.toString();
      }
      if (data['error'] != null) return data['error'].toString();
    }
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Cannot reach the server. Check your connection and try again.';
      default:
        break;
    }
  }
  return 'Something went wrong. Please try again.';
}
