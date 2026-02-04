import 'package:equatable/equatable.dart';
import 'delivery_status.dart';

class DeliveryFilter extends Equatable {
  final DeliveryStatus? status;
  final String? searchQuery;
  final int page;
  final int limit;
  final String? sortBy;
  final bool ascending;

  const DeliveryFilter({
    this.status,
    this.searchQuery,
    this.page = 1,
    this.limit = 20,
    this.sortBy,
    this.ascending = true,
  });

  DeliveryFilter copyWith({
    DeliveryStatus? status,
    String? searchQuery,
    int? page,
    int? limit,
    String? sortBy,
    bool? ascending,
  }) {
    return DeliveryFilter(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  @override
  List<Object?> get props => [status, searchQuery, page, limit, sortBy, ascending];
}
