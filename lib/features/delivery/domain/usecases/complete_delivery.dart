import 'package:injectable/injectable.dart';
import '../entities/delivery.dart';
import '../repositories/delivery_repository.dart';

@injectable
class CompleteDelivery {
  final DeliveryRepository _repository;

  const CompleteDelivery(this._repository);

  Future<Delivery> call(String deliveryId) async {
    return await _repository.completeDelivery(deliveryId);
  }
}
