import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class EncryptionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    
    super.onResponse(response, handler);
  }
}
