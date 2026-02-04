import 'package:bloc/bloc.dart';
import 'package:delivero/core/di/injection.dart';
import 'package:delivero/core/network/network_info.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/delivery_repository.dart';

part 'offline_sync_state.dart';

class OfflineSyncCubit extends Cubit<OfflineSyncState> {
  OfflineSyncCubit() : super(OfflineSyncInitial());

  Future<void> checkConnectivity() async {
    final networkInfo = getIt<NetworkInfo>();
    final isConnected = await networkInfo.isConnected;
    emit(OfflineSyncStatus(isOnline: isConnected));
  }

  Future<void> syncOfflineChanges() async {
    emit(OfflineSyncLoading());

    try {
      final deliveryRepository = getIt<DeliveryRepository>();
      await deliveryRepository.syncOfflineChanges();
      emit(OfflineSyncSuccess());
    } catch (e) {
      emit(OfflineSyncError(message: e.toString()));
    }
  }

  void listenToConnectivity() {
    final networkInfo = getIt<NetworkInfo>();
    networkInfo.connectivityStream.listen((isConnected) {
      emit(OfflineSyncStatus(isOnline: isConnected));

      if (isConnected) {
        syncOfflineChanges();
      }
    });
  }
}
