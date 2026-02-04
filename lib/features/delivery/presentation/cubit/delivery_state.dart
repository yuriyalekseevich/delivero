part of 'delivery_cubit.dart';

abstract class DeliveryState extends Equatable {
  const DeliveryState();

  @override
  List<Object?> get props => [];
}

class DeliveryInitial extends DeliveryState {}

class DeliveryLoading extends DeliveryState {}

class DeliveryLoaded extends DeliveryState {
  final List<Delivery> deliveries;

  const DeliveryLoaded({required this.deliveries});

  @override
  List<Object> get props => [deliveries];
}

class DeliveryError extends DeliveryState {
  final String message;

  const DeliveryError({required this.message});

  @override
  List<Object> get props => [message];
}

class DeliveryOfflineNotification extends DeliveryState {
  final String message;

  const DeliveryOfflineNotification({required this.message});

  @override
  List<Object> get props => [message];
}
