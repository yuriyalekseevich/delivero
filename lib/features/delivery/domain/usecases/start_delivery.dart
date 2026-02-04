import 'package:injectable/injectable.dart';
import '../entities/delivery.dart';
import '../repositories/delivery_repository.dart';

@injectable
class StartDelivery {
  final DeliveryRepository _repository;

  const StartDelivery(this._repository);

  Future<Delivery> call(String deliveryId) async {
    return await _repository.startDelivery(deliveryId);
  }
}
