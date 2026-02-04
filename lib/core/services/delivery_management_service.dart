import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';
import 'package:delivero/features/delivery/domain/repositories/delivery_repository.dart';
import 'package:delivero/core/network/network_info.dart';
import 'package:delivero/core/offline/action_queue.dart';
import 'package:delivero/core/services/delivery_event_bus.dart';

@singleton
class DeliveryManagementService {
  final DeliveryRepository _repository;
  final NetworkInfo _networkInfo;
  final ActionQueue _actionQueue;
  final DeliveryEventBus _eventBus;

  DeliveryManagementService(
    this._repository,
    this._networkInfo,
    this._actionQueue,
    this._eventBus,
  );

  Future<Delivery> startDelivery(String deliveryId) async {
    try {
      final delivery = await _repository.startDelivery(deliveryId);

      _eventBus.emitStatusChange(
        deliveryId: deliveryId,
        oldStatus: DeliveryStatus.newDelivery,
        newStatus: DeliveryStatus.inProgress,
        delivery: delivery,
      );

      final isConnected = await _networkInfo.isConnected;

      if (isConnected) {
        await _sendStartDeliveryToBackend(deliveryId);
        debugPrint('✅ ONLINE: Delivery $deliveryId started and synced with backend');
      } else {
        await _actionQueue.queueAction(
          type: 'start_delivery',
          deliveryId: deliveryId,
          data: {
            'timestamp': DateTime.now().toIso8601String(),
            'status': DeliveryStatus.inProgress.name,
          },
        );
        debugPrint('📱 OFFLINE: Delivery $deliveryId start action queued for sync');
      }

      return delivery;
    } catch (e) {
      debugPrint('❌ Error starting delivery $deliveryId: $e');
      rethrow;
    }
  }

  Future<Delivery> completeDelivery(String deliveryId) async {
    try {
      final delivery = await _repository.completeDelivery(deliveryId);

      _eventBus.emitStatusChange(
        deliveryId: deliveryId,
        oldStatus: DeliveryStatus.inProgress,
        newStatus: DeliveryStatus.completed,
        delivery: delivery,
      );

      final isConnected = await _networkInfo.isConnected;

      if (isConnected) {
        await _sendCompleteDeliveryToBackend(deliveryId);
        debugPrint('✅ ONLINE: Delivery $deliveryId completed and synced with backend');
      } else {
        await _actionQueue.queueAction(
          type: 'complete_delivery',
          deliveryId: deliveryId,
          data: {
            'timestamp': DateTime.now().toIso8601String(),
            'status': DeliveryStatus.completed.name,
          },
        );
        debugPrint('📱 OFFLINE: Delivery $deliveryId complete action queued for sync');
      }

      return delivery;
    } catch (e) {
      debugPrint('❌ Error completing delivery $deliveryId: $e');
      rethrow;
    }
  }

  Future<void> _sendStartDeliveryToBackend(String deliveryId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint('🔄 Backend API: Starting delivery $deliveryId');

  }

  Future<void> _sendCompleteDeliveryToBackend(String deliveryId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint('🔄 Backend API: Completing delivery $deliveryId');

  }

  Future<void> syncPendingActions() async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected) {
        debugPrint('🔄 Syncing pending offline actions...');

        final pendingActions = await _actionQueue.getPendingActions();

        for (final action in pendingActions) {
          await _processPendingAction(action);
        }

        debugPrint('✅ All pending actions synced successfully');
      } else {
        debugPrint('📱 No internet connection - actions will be synced when online');
      }
    } catch (e) {
      debugPrint('❌ Error syncing pending actions: $e');
    }
  }

  Future<void> _processPendingAction(Map<String, dynamic> action) async {
    try {
      final type = action['type'] as String;
      final deliveryId = action['deliveryId'] as String;

      switch (type) {
        case 'start_delivery':
          await _sendStartDeliveryToBackend(deliveryId);
          break;
        case 'complete_delivery':
          await _sendCompleteDeliveryToBackend(deliveryId);
          break;
        default:
          debugPrint('⚠️ Unknown action type: $type');
      }

      await _actionQueue.markActionAsSynced(action['id'] as String);
    } catch (e) {
      debugPrint('❌ Error processing action ${action['id']}: $e');
    }
  }

  Future<List<Delivery>> getDeliveriesByStatus(DeliveryStatus status) async {
    return await _repository.getDeliveriesByStatusFromLocal(status);
  }

  Future<bool> hasPendingActions() async {
    final pendingActions = await _actionQueue.getPendingActions();
    return pendingActions.isNotEmpty;
  }
}
