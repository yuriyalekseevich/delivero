import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'injection.config.dart';
import '../storage/hive_storage.dart';
import '../storage/debug_storage.dart';
import '../offline/action_queue.dart';
import '../../features/delivery/data/models/delivery_model.dart';
import '../../features/delivery/data/models/delivery_event_model.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // await HiveStorage.init();

  // if (!Hive.isAdapterRegistered(0)) {
  //   Hive.registerAdapter(DeliveryModelAdapter());
  // }
  // if (!Hive.isAdapterRegistered(1)) {
  //   Hive.registerAdapter(DeliveryEventModelAdapter());
  // }

  await getIt.init();

  final debugStorage = getIt<DebugStorage>();
  await debugStorage.init();

  final actionQueue = getIt<ActionQueue>();
  await actionQueue.initialize();
}
