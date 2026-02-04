part of 'offline_sync_cubit.dart';

abstract class OfflineSyncState extends Equatable {
  const OfflineSyncState();

  @override
  List<Object?> get props => [];
}

class OfflineSyncInitial extends OfflineSyncState {}

class OfflineSyncLoading extends OfflineSyncState {}

class OfflineSyncStatus extends OfflineSyncState {
  final bool isOnline;

  const OfflineSyncStatus({required this.isOnline});

  @override
  List<Object> get props => [isOnline];
}

class OfflineSyncSuccess extends OfflineSyncState {}

class OfflineSyncError extends OfflineSyncState {
  final String message;

  const OfflineSyncError({required this.message});

  @override
  List<Object> get props => [message];
}
