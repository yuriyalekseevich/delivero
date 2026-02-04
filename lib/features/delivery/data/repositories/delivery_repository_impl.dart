import 'package:delivero/core/error/exceptions.dart';
import 'package:delivero/core/error/failures.dart';
import 'package:delivero/core/network/network_info.dart';
import 'package:delivero/core/offline/action_queue.dart';
import 'package:delivero/core/offline/offline_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';
import '../../domain/entities/delivery_filter.dart';
import '../../domain/entities/paginated_deliveries.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/delivery_local_datasource.dart';
import '../datasources/mock_delivery_api_service.dart';

@LazySingleton(as: DeliveryRepository)
class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final ActionQueue _actionQueue;
  final OfflineModeCubit _offlineModeCubit;
  final MockDeliveryApiService _mockApiService;

  DeliveryRepositoryImpl(
    this._localDataSource,
    this._networkInfo,
    this._actionQueue,
    this._offlineModeCubit,
    this._mockApiService,
  );

  @override
  Future<List<Delivery>> getDeliveries() async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected) {
        final deliveries = await _mockApiService.getAllDeliveries();
        await _localDataSource.saveDeliveries(deliveries);
        return deliveries;
      } else {
        return await _localDataSource.getDeliveries();
      }
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    }
  }

  @override
  Future<Delivery?> getDeliveryById(String id) async {
    try {
      return await _localDataSource.getDeliveryById(id);
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    }
  }

  @override
  Future<Delivery> startDelivery(String id) async {
    try {
      final delivery = await _localDataSource.startDelivery(id);
      await _localDataSource.saveDelivery(delivery);

      if (_offlineModeCubit.isOffline) {
        await _actionQueue.queueAction(
          type: 'start_delivery',
          deliveryId: id,
          data: {'timestamp': DateTime.now().toIso8601String()},
        );
        debugPrint('📱 OFFLINE MODE: Delivery $id start action queued');
        return delivery;
      }

      final isConnected = await _networkInfo.isConnected;
      if (isConnected) {
        await _mockApiService.startDelivery(id);
        debugPrint('✅ ONLINE MODE: Delivery $id started successfully');
      } else {
        await _actionQueue.queueAction(
          type: 'start_delivery',
          deliveryId: id,
          data: {'timestamp': DateTime.now().toIso8601String()},
        );
        debugPrint('📱 OFFLINE: Delivery $id start action queued');
      }

      return delivery;
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } on ValidationException catch (e) {
      throw ValidationFailure(message: e.message);
    }
  }

  @override
  Future<Delivery> completeDelivery(String id) async {
    try {
      final delivery = await _localDataSource.completeDelivery(id);
      await _localDataSource.saveDelivery(delivery);

      if (_offlineModeCubit.isOffline) {
        await _actionQueue.queueAction(
          type: 'complete_delivery',
          deliveryId: id,
          data: {'timestamp': DateTime.now().toIso8601String()},
        );
        debugPrint('📱 OFFLINE MODE: Delivery $id complete action queued');
        return delivery;
      }

      final isConnected = await _networkInfo.isConnected;
      if (isConnected) {
        await _mockApiService.completeDelivery(id);
        debugPrint('✅ ONLINE MODE: Delivery $id completed successfully');
      } else {
        await _actionQueue.queueAction(
          type: 'complete_delivery',
          deliveryId: id,
          data: {'timestamp': DateTime.now().toIso8601String()},
        );
        debugPrint('📱 OFFLINE: Delivery $id complete action queued');
      }

      return delivery;
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } on ValidationException catch (e) {
      throw ValidationFailure(message: e.message);
    }
  }

  @override
  Future<void> syncOfflineChanges() async {
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      debugPrint('Syncing offline changes with server...');
      await Future.delayed(const Duration(seconds: 2)); 
      debugPrint('Offline changes synced successfully');
    } else {
      debugPrint('No internet connection - changes will be synced when online');
    }
  }

  @override
  Stream<List<Delivery>> watchDeliveries() {
    return _localDataSource.watchDeliveries();
  }

  @override
  Future<PaginatedDeliveries> getDeliveriesPaginated(DeliveryFilter filter) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected) {
        switch (filter.status) {
          case DeliveryStatus.newDelivery:
            return await _mockApiService.getNewDeliveries(
              page: filter.page,
              limit: 10,
              searchQuery: filter.searchQuery,
            );
          case DeliveryStatus.inProgress:
            return await _mockApiService.getActiveDeliveries(
              page: filter.page,
              limit: 10,
              searchQuery: filter.searchQuery,
            );
          case DeliveryStatus.completed:
            return await _mockApiService.getCompletedDeliveries(
              page: filter.page,
              limit: 10,
              searchQuery: filter.searchQuery,
            );
          case null:
            final allDeliveries = await _mockApiService.getAllDeliveries();
            await _localDataSource.saveDeliveries(allDeliveries);
            return await _localDataSource.getDeliveriesPaginated(filter);
        }
      } else {
        return await _localDataSource.getDeliveriesPaginated(filter);
      }
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    }
  }

  @override
  Future<List<Delivery>> getDeliveriesByStatus(DeliveryStatus status) async {
    try {
      return await _localDataSource.getDeliveriesByStatus(status);
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    }
  }

  @override
  Future<List<Delivery>> searchDeliveries(String query) async {
    try {
      return await _localDataSource.searchDeliveries(query);
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    }
  }

  @override
  Stream<PaginatedDeliveries> watchDeliveriesPaginated(DeliveryFilter filter) {
    return _localDataSource.watchDeliveriesPaginated(filter);
  }

  @override
  Future<void> saveDeliveriesByStatus(DeliveryStatus status, List<Delivery> deliveries) async {
    try {
      await _localDataSource.saveDeliveriesByStatus(status, deliveries);
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    }
  }

  @override
  Future<List<Delivery>> getDeliveriesByStatusFromLocal(DeliveryStatus status) async {
    try {
      return await _localDataSource.getDeliveriesByStatus(status);
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    }
  }
}
