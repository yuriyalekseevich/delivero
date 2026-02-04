import 'package:bloc/bloc.dart';
import 'package:delivero/core/di/injection.dart';
import 'package:delivero/core/error/failures.dart';
import 'package:delivero/core/network/network_info.dart';
import 'package:delivero/core/services/delivery_management_service.dart';
import 'package:delivero/features/delivery/domain/usecases/get_deliveries.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(DeliveryInitial());

  Future<void> loadDeliveries() async {
    emit(DeliveryLoading());

    try {
      final getDeliveries = getIt<GetDeliveries>();
      final deliveries = await getDeliveries();
      emit(DeliveryLoaded(deliveries: deliveries));
    } on ServerFailure catch (e) {
      emit(DeliveryError(message: e.message));
    } on NetworkFailure catch (e) {
      emit(DeliveryError(message: e.message));
    } on CacheFailure catch (e) {
      emit(DeliveryError(message: e.message));
    }
  }

  Future<void> checkConnectivityAndShowMessage() async {
    final networkInfo = getIt<NetworkInfo>();
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      emit(const DeliveryOfflineNotification(
        message: 'No internet connection. Data will be stored locally until next connection.',
      ));
    }
  }

  Future<void> startDelivery(String deliveryId) async {
    try {
      final deliveryManagementService = getIt<DeliveryManagementService>();
      final delivery = await deliveryManagementService.startDelivery(deliveryId);

      if (state is DeliveryLoaded) {
        final currentDeliveries = (state as DeliveryLoaded).deliveries;
        final updatedDeliveries = currentDeliveries.map((d) {
          return d.id == deliveryId ? delivery : d;
        }).toList();

        emit(DeliveryLoaded(deliveries: updatedDeliveries));
      }
    } on ServerFailure catch (e) {
      emit(DeliveryError(message: e.message));
    } on NetworkFailure catch (e) {
      emit(DeliveryError(message: e.message));
    } on CacheFailure catch (e) {
      emit(DeliveryError(message: e.message));
    } on ValidationFailure catch (e) {
      emit(DeliveryError(message: e.message));
    }
  }

  Future<void> completeDelivery(String deliveryId) async {
    try {
      final deliveryManagementService = getIt<DeliveryManagementService>();
      final delivery = await deliveryManagementService.completeDelivery(deliveryId);

      if (state is DeliveryLoaded) {
        final currentDeliveries = (state as DeliveryLoaded).deliveries;
        final updatedDeliveries = currentDeliveries.map((d) {
          return d.id == deliveryId ? delivery : d;
        }).toList();

        emit(DeliveryLoaded(deliveries: updatedDeliveries));
      }
    } on ServerFailure catch (e) {
      emit(DeliveryError(message: e.message));
    } on NetworkFailure catch (e) {
      emit(DeliveryError(message: e.message));
    } on CacheFailure catch (e) {
      emit(DeliveryError(message: e.message));
    } on ValidationFailure catch (e) {
      emit(DeliveryError(message: e.message));
    }
  }

  List<Delivery> getDeliveriesByStatus(DeliveryStatus status) {
    if (state is DeliveryLoaded) {
      return (state as DeliveryLoaded).deliveries.where((delivery) => delivery.status == status).toList();
    }
    return [];
  }
}
