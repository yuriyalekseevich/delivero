import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../features/delivery/data/models/delivery_model.dart';
import '../network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  NetworkInfo networkInfo(Connectivity connectivity) => NetworkInfoImpl(connectivity: connectivity);

  @preResolve
  Future<Box<DeliveryModel>> openDeliveryBox() async {
    return await Hive.openBox<DeliveryModel>('deliveryBox');
  }
}
