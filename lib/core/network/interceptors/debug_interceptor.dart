import 'package:delivero/core/di/injection.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../storage/debug_storage.dart';

@injectable
class DebugInterceptor extends Interceptor {
  DebugInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    getIt<DebugStorage>().logRequest(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    getIt<DebugStorage>().logResponse(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    getIt<DebugStorage>().logError(err);
    super.onError(err, handler);
  }
}
