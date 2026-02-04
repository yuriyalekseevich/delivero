import 'package:injectable/injectable.dart';
import '../entities/delivery_status.dart';
import '../entities/delivery_filter.dart';
import '../entities/paginated_deliveries.dart';
import '../repositories/delivery_repository.dart';

@injectable
class GetReadyDeliveries {
  final DeliveryRepository _repository;

  const GetReadyDeliveries(this._repository);

  Future<PaginatedDeliveries> call({
    int page = 1,
    int limit = 20,
    String? searchQuery,
  }) async {
    final filter = DeliveryFilter(
      status: DeliveryStatus.newDelivery,
      searchQuery: searchQuery,
      page: page,
      limit: limit,
      sortBy: 'createdAt',
      ascending: false, 
    );

    return await _repository.getDeliveriesPaginated(filter);
  }
}
