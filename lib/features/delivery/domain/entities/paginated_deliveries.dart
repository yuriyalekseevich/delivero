import 'package:equatable/equatable.dart';
import 'delivery.dart';

class PaginatedDeliveries extends Equatable {
  final List<Delivery> deliveries;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedDeliveries({
    required this.deliveries,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  @override
  List<Object> get props => [
        deliveries,
        currentPage,
        totalPages,
        totalItems,
        hasNextPage,
        hasPreviousPage,
      ];
}
