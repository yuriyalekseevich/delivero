import 'package:delivero/core/error/exceptions.dart';
import 'package:delivero/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/delivery_model.dart';
import '../../domain/entities/delivery.dart';

abstract class DeliveryRemoteDataSource {
  Future<List<Delivery>> getDeliveries();
  Future<Delivery> startDelivery(String id);
  Future<Delivery> completeDelivery(String id);
  Future<void> syncOfflineChanges(List<Delivery> deliveries);
}

@Injectable(as: DeliveryRemoteDataSource)
class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  final ApiClient _apiClient;

  DeliveryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Delivery>> getDeliveries() async {
    try {
      final response = await _apiClient.deliveryApi.get('/deliveries');
      final List<dynamic> data = response.data;
      return data.map((json) => DeliveryModel.fromJson(json).toEntity()).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to fetch deliveries',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Delivery> startDelivery(String id) async {
    try {
      final response = await _apiClient.deliveryApi.post('/deliveries/$id/start');
      return DeliveryModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to start delivery',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Delivery> completeDelivery(String id) async {
    try {
      final response = await _apiClient.deliveryApi.post('/deliveries/$id/complete');
      return DeliveryModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to complete delivery',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> syncOfflineChanges(List<Delivery> deliveries) async {
    try {
      await _apiClient.deliveryApi.post('/deliveries/sync', data: {
        'deliveries': deliveries.map((d) => DeliveryModel.fromEntity(d).toJson()).toList(),
      });
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] ?? 'Failed to sync deliveries',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
