import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

@singleton
class DebugStorage {
  static const String _boxName = AppConstants.debugLogsBox;
  late Box<Map> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);
  }

  void logRequest(RequestOptions options) {
    final logEntry = {
      'type': 'request',
      'timestamp': DateTime.now().toIso8601String(),
      'method': options.method,
      'url': options.uri.toString(),
      'headers': options.headers,
      'data': options.data,
    };
    _box.add(logEntry);
  }

  void logResponse(Response response) {
    final logEntry = {
      'type': 'response',
      'timestamp': DateTime.now().toIso8601String(),
      'statusCode': response.statusCode,
      'url': response.requestOptions.uri.toString(),
      'data': response.data,
    };
    _box.add(logEntry);
  }

  void logError(DioException error) {
    final logEntry = {
      'type': 'error',
      'timestamp': DateTime.now().toIso8601String(),
      'error': error.message,
      'statusCode': error.response?.statusCode,
      'url': error.requestOptions.uri.toString(),
      'data': error.response?.data,
    };
    _box.add(logEntry);
  }

  List<Map> getAllLogs() {
    return _box.values.toList();
  }

  void clearLogs() {
    _box.clear();
  }

  void close() {
    _box.close();
  }
}
