import 'package:dio/dio.dart';

String getErrorMessage(Object? e, [String defaultMessage = 'An unexpected error occurred']) {
  if (e is DioException) {
    if (e.response?.data != null && e.response?.data is Map) {
      return (e.response?.data as Map)['message']?.toString() ?? 
             (e.response?.data as Map)['error']?.toString() ?? 
             defaultMessage;
    }
    
    // Distinguish common network issues without technical jargon
    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.sendTimeout || 
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please check your internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection.';
    }
    
    return defaultMessage;
  }
  return defaultMessage;
}
