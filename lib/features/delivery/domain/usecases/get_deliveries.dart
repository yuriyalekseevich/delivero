import 'package:injectable/injectable.dart';
import '../entities/delivery.dart';
import '../repositories/delivery_repository.dart';

@injectable
class GetDeliveries {
  final DeliveryRepository _repository;

  const GetDeliveries(this._repository);

  Future<List<Delivery>> call() async {
    return await _repository.getDeliveries();
  }
}
