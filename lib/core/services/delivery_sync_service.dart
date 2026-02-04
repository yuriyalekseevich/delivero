import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';
import 'package:delivero/features/delivery/domain/repositories/delivery_repository.dart';
import 'package:delivero/features/delivery/data/datasources/mock_delivery_api_service.dart';
import 'package:delivero/core/network/network_info.dart';

@singleton
class DeliverySyncService {
  final DeliveryRepository _repository;
  final NetworkInfo _networkInfo;
  final MockDeliveryApiService _mockApiService;

  DeliverySyncService(
    this._repository,
    this._networkInfo,
    this._mockApiService,
  );

  Future<void> performInitialSync() async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected) {
        final newDeliveries = await _mockApiService.getNewDeliveries(page: 1, limit: 100);
        final activeDeliveries = await _mockApiService.getActiveDeliveries(page: 1, limit: 100);
        final completedDeliveries = await _mockApiService.getCompletedDeliveries(page: 1, limit: 100);

        await _repository.saveDeliveriesByStatus(DeliveryStatus.newDelivery, newDeliveries.deliveries);
        await _repository.saveDeliveriesByStatus(DeliveryStatus.inProgress, activeDeliveries.deliveries);
        await _repository.saveDeliveriesByStatus(DeliveryStatus.completed, completedDeliveries.deliveries);

        await _processOfflineActions();
      } else {
        await _loadFromLocalStorage();
      }
    } catch (e) {
      await _loadFromLocalStorage();
    }
  }

  Future<void> _loadFromLocalStorage() async {
  }

  Future<void> _processOfflineActions() async {
    try {
      await _repository.syncOfflineChanges();
    } catch (e) {
      debugPrint('Error syncing offline changes: $e');
    }
  }

  Future<bool> needsInitialSync() async {
    final localDeliveries = await _repository.getDeliveriesByStatus(DeliveryStatus.newDelivery);
    return localDeliveries.isEmpty;
  }

  Future<void> syncWhenOnline() async {
    final isConnected = await _networkInfo.isConnected;
    if (isConnected) {
      await performInitialSync();
    }
  }
}
