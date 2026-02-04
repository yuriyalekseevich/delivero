part of 'delivery_list_cubit.dart';

abstract class DeliveryListState extends Equatable {
  const DeliveryListState();

  @override
  List<Object?> get props => [];
}

class DeliveryListInitial extends DeliveryListState {}

class DeliveryListLoading extends DeliveryListState {}

class DeliveryListLoaded extends DeliveryListState {
  final List<Delivery> deliveries;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String tab;

  const DeliveryListLoaded({
    required this.deliveries,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.tab,
  });

  @override
  List<Object> get props => [
        deliveries,
        currentPage,
        totalPages,
        hasNextPage,
        hasPreviousPage,
        tab,
      ];
}

class DeliveryListError extends DeliveryListState {
  final String message;

  const DeliveryListError({required this.message});

  @override
  List<Object> get props => [message];
}

class DeliveryListPaginationLoading extends DeliveryListState {
  final List<Delivery> deliveries;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String tab;

  const DeliveryListPaginationLoading({
    required this.deliveries,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.tab,
  });

  @override
  List<Object> get props => [
        deliveries,
        currentPage,
        totalPages,
        hasNextPage,
        hasPreviousPage,
        tab,
      ];
}
