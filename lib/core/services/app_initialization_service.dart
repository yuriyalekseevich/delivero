import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:delivero/core/network/network_info.dart';
import 'package:delivero/core/services/delivery_sync_service.dart';
import 'package:delivero/core/services/delivery_management_service.dart';

@injectable
class AppInitializationService {
  final NetworkInfo _networkInfo;
  final DeliverySyncService _syncService;
  final DeliveryManagementService _managementService;

  AppInitializationService(
    this._networkInfo,
    this._syncService,
    this._managementService,
  );

  Future<void> initializeApp() async {
    try {
      log('🚀 Initializing app...');

      final needsSync = await _syncService.needsInitialSync();

      if (needsSync) {
        log('📡 Performing initial data sync...');
        await _syncService.performInitialSync();
        log('✅ Initial sync completed');
      } else {
        log('📱 Loading from local storage...');
        await _syncService.performInitialSync();
        log('✅ Local data loaded');
      }

      final isConnected = await _networkInfo.isConnected;
      if (isConnected) {
        log('🔄 Syncing pending offline actions...');
        await _managementService.syncPendingActions();
        log('✅ Pending actions synced');
      } else {
        log('📱 Offline mode - pending actions will be synced when online');
      }

      log('🎉 App initialization completed successfully');
    } catch (e) {
      log('❌ Error during app initialization: $e');
    }
  }

  Future<void> handleInternetRestored() async {
    try {
      log('🌐 Internet connection restored - syncing data...');

      await _syncService.performInitialSync();

      await _managementService.syncPendingActions();

      log('✅ Data sync completed after internet restoration');
    } catch (e) {
      log('❌ Error syncing after internet restoration: $e');
    }
  }

  Future<bool> hasPendingActions() async {
    return await _managementService.hasPendingActions();
  }
}
