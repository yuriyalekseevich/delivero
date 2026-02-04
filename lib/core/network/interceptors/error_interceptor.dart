import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../error/exceptions.dart';

@injectable
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = const NetworkException(message: 'Connection timeout');
        break;
      case DioExceptionType.badResponse:
        exception = ServerException(
          message: err.response?.data?['message'] ?? 'Server error',
          statusCode: err.response?.statusCode,
        );
        break;
      case DioExceptionType.cancel:
        exception = const NetworkException(message: 'Request cancelled');
        break;
      case DioExceptionType.connectionError:
        exception = const NetworkException(message: 'No internet connection');
        break;
      case DioExceptionType.badCertificate:
        exception = const NetworkException(message: 'Certificate error');
        break;
      case DioExceptionType.unknown:
        exception = NetworkException(message: err.message ?? 'Unknown error');
        break;
    }

    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: exception,
      type: err.type,
      response: err.response,
    ));
  }
}
