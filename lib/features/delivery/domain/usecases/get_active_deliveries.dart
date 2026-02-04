import 'package:injectable/injectable.dart';
import '../entities/delivery_status.dart';
import '../entities/delivery_filter.dart';
import '../entities/paginated_deliveries.dart';
import '../repositories/delivery_repository.dart';

@injectable
class GetActiveDeliveries {
  final DeliveryRepository _repository;

  const GetActiveDeliveries(this._repository);

  Future<PaginatedDeliveries> call({
    int page = 1,
    int limit = 20,
    String? searchQuery,
  }) async {
    final filter = DeliveryFilter(
      status: DeliveryStatus.inProgress,
      searchQuery: searchQuery,
      page: page,
      limit: limit,
      sortBy: 'updatedAt',
      ascending: false, 
    );

    return await _repository.getDeliveriesPaginated(filter);
  }
}
