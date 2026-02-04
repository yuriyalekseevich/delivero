import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
class ActionQueue {
  static const String _queueBoxName = 'action_queue';
  Box<Map>? _queueBox;
  final Uuid _uuid = const Uuid();

  Future<void> initialize() async {
    _queueBox = await Hive.openBox<Map>(_queueBoxName);
  }

  Future<void> _ensureInitialized() async {
    if (_queueBox == null) {
      await initialize();
    }
  }

  Future<String> queueAction({
    required String type,
    required String deliveryId,
    Map<String, dynamic>? data,
  }) async {
    await _ensureInitialized();

    final actionId = _uuid.v4();
    final action = {
      'id': actionId,
      'type': type,
      'deliveryId': deliveryId,
      'data': data ?? {},
      'timestamp': DateTime.now().toIso8601String(),
      'synced': false,
    };

    await _queueBox!.put(actionId, action);
    debugPrint('📝 QUEUED ACTION: $type for delivery $deliveryId (ID: $actionId)');
    return actionId;
  }

  Future<List<Map<String, dynamic>>> getQueuedActions() async {
    await _ensureInitialized();

    final actions = <Map<String, dynamic>>[];
    for (final key in _queueBox!.keys) {
      final action = _queueBox!.get(key);
      if (action != null && action['synced'] == false) {
        actions.add(Map<String, dynamic>.from(action));
      }
    }

    actions.sort((a, b) => DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp'])));
    return actions;
  }

  Future<void> markActionAsSynced(String actionId) async {
    await _ensureInitialized();

    final action = _queueBox!.get(actionId);
    if (action != null) {
      action['synced'] = true;
      await _queueBox!.put(actionId, action);
      debugPrint('✅ MARKED AS SYNCED: Action $actionId');
    }
  }

  Future<void> clearSyncedActions() async {
    await _ensureInitialized();

    final keysToDelete = <String>[];
    for (final key in _queueBox!.keys) {
      final action = _queueBox!.get(key);
      if (action != null && action['synced'] == true) {
        keysToDelete.add(key.toString());
      }
    }

    for (final key in keysToDelete) {
      await _queueBox!.delete(key);
    }

    if (keysToDelete.isNotEmpty) {
      debugPrint('🧹 CLEARED ${keysToDelete.length} synced actions');
    }
  }

  Future<int> getQueuedActionsCount() async {
    await _ensureInitialized();

    int count = 0;
    for (final key in _queueBox!.keys) {
      final action = _queueBox!.get(key);
      if (action != null && action['synced'] == false) {
        count++;
      }
    }
    return count;
  }

  Future<void> clearAllActions() async {
    await _ensureInitialized();
    await _queueBox!.clear();
    debugPrint('🧹 CLEARED ALL ACTIONS');
  }

  Future<List<Map<String, dynamic>>> getPendingActions() async {
    return await getQueuedActions();
  }
}
