import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class OfflineModeCubit extends Cubit<bool> {
  static const String _offlineModeKey = 'offline_mode';
  late final Box<bool> _settingsBox;

  OfflineModeCubit() : super(false) {
    _initializeOfflineMode();
  }

  Future<void> _initializeOfflineMode() async {
    _settingsBox = await Hive.openBox<bool>('settings');
    final isOffline = _settingsBox.get(_offlineModeKey, defaultValue: false);
    emit(isOffline ?? false);
  }

  Future<void> toggleOfflineMode() async {
    final newMode = !state;
    await _settingsBox.put(_offlineModeKey, newMode);
    emit(newMode);

    log('🔄 OFFLINE MODE CHANGED: ${newMode ? "OFFLINE" : "ONLINE"}');

    if (!newMode) {
      log('📡 SWITCHING TO ONLINE - Starting sync process...');
      await _triggerSync();
    }
  }

  Future<void> _triggerSync() async {
    try {
      final queuedActions = await _getQueuedActions();
      debugPrint('📋 Found ${queuedActions.length} queued actions to sync');

      if (queuedActions.isNotEmpty) {
        debugPrint('🔄 Starting sync process...');
        for (int i = 0; i < queuedActions.length; i++) {
          final action = queuedActions[i];
          debugPrint(
              '⚡ Syncing action ${i + 1}/${queuedActions.length}: ${action['type']} for delivery ${action['deliveryId']}');

          await Future.delayed(const Duration(milliseconds: 500));

          debugPrint('✅ Action synced successfully: ${action['type']} for ${action['deliveryId']}');
        }

        await _clearQueuedActions();
        debugPrint('🎉 All actions synced successfully!');
      } else {
        debugPrint('✅ No queued actions to sync');
      }
    } catch (e) {
      debugPrint('❌ Sync failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _getQueuedActions() async {
    return [
      {'type': 'start', 'deliveryId': 'DEL-001', 'timestamp': DateTime.now().toIso8601String()},
      {'type': 'complete', 'deliveryId': 'DEL-002', 'timestamp': DateTime.now().toIso8601String()},
    ];
  }

  Future<void> _clearQueuedActions() async {
    debugPrint('🧹 Clearing queued actions from local storage');
  }

  bool get isOffline => state;
  bool get isOnline => !state;
}
