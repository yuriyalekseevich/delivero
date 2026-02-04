import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';

import '../entities/delivery.dart';
import '../entities/delivery_filter.dart';
import '../entities/paginated_deliveries.dart';

abstract class DeliveryRepository {
  Future<List<Delivery>> getDeliveries();

  Future<PaginatedDeliveries> getDeliveriesPaginated(DeliveryFilter filter);
  Future<List<Delivery>> getDeliveriesByStatus(DeliveryStatus status);
  Future<List<Delivery>> searchDeliveries(String query);

  Future<Delivery?> getDeliveryById(String id);
  Future<Delivery> startDelivery(String id);
  Future<Delivery> completeDelivery(String id);

  Future<void> syncOfflineChanges();
  Stream<List<Delivery>> watchDeliveries();
  Stream<PaginatedDeliveries> watchDeliveriesPaginated(DeliveryFilter filter);

  Future<void> saveDeliveriesByStatus(DeliveryStatus status, List<Delivery> deliveries);
  Future<List<Delivery>> getDeliveriesByStatusFromLocal(DeliveryStatus status);
}
