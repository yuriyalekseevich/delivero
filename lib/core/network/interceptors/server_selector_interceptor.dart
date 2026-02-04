import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../constants/app_constants.dart';

@injectable
class ServerSelectorInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.startsWith('/delivery')) {
      options.baseUrl = AppConstants.deliveryApiUrl;
    } else if (options.path.startsWith('/payment')) {
      options.baseUrl = AppConstants.paymentApiUrl;
    } else if (options.path.startsWith('/grocery')) {
      options.baseUrl = AppConstants.groceryApiUrl;
    }

    super.onRequest(options, handler);
  }
}
