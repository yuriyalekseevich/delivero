import 'package:delivero/features/delivery/presentation/cubit/offline_sync_cubit.dart';
import 'package:delivero/generated/l10n.dart';
import 'package:flutter/material.dart';

class OfflineIndicator extends StatelessWidget {
  final OfflineSyncState state;

  const OfflineIndicator({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is OfflineSyncStatus) {
      final isOnline = (state as OfflineSyncStatus).isOnline;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isOnline ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              isOnline ? S.of(context).online : S.of(context).offline,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
