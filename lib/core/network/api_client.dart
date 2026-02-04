import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import 'interceptors/debug_interceptor.dart';
import 'interceptors/encryption_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/server_selector_interceptor.dart';

@injectable
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      sendTimeout: AppConstants.apiTimeout,
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      ServerSelectorInterceptor(),
      EncryptionInterceptor(),
      DebugInterceptor(),
      ErrorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => log(object.toString()),
      ),
    ]);
  }

  Dio get dio => _dio;

  Dio get deliveryApi {
    final dio = Dio(_dio.options);
    dio.options.baseUrl = AppConstants.deliveryApiUrl;
    dio.interceptors.addAll(_dio.interceptors);
    return dio;
  }

  Dio get paymentApi {
    final dio = Dio(_dio.options);
    dio.options.baseUrl = AppConstants.paymentApiUrl;
    dio.interceptors.addAll(_dio.interceptors);
    return dio;
  }

  Dio get groceryApi {
    final dio = Dio(_dio.options);
    dio.options.baseUrl = AppConstants.groceryApiUrl;
    dio.interceptors.addAll(_dio.interceptors);
    return dio;
  }
}
