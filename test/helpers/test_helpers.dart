import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:delivero/features/delivery/domain/usecases/get_deliveries.dart';
import 'package:delivero/features/delivery/domain/usecases/get_ready_deliveries.dart';
import 'package:delivero/features/delivery/domain/usecases/get_active_deliveries.dart';
import 'package:delivero/features/delivery/domain/usecases/get_completed_deliveries.dart';
import 'package:delivero/core/services/delivery_management_service.dart';
import 'package:delivero/core/services/delivery_event_bus.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';
import 'package:delivero/features/delivery/domain/entities/paginated_deliveries.dart';
import 'package:delivero/generated/l10n.dart';

class MockGetDeliveries extends Mock implements GetDeliveries {}

class MockGetReadyDeliveries extends Mock implements GetReadyDeliveries {}

class MockGetActiveDeliveries extends Mock implements GetActiveDeliveries {}

class MockGetCompletedDeliveries extends Mock implements GetCompletedDeliveries {}

class MockDeliveryManagementService extends Mock implements DeliveryManagementService {}

class MockDeliveryEventBus extends Mock implements DeliveryEventBus {}

class TestHelpers {
  static Widget createTestApp({
    required Widget child,
    List<LocalizationsDelegate>? localizationsDelegates,
    List<Locale>? supportedLocales,
  }) {
    return MaterialApp(
      localizationsDelegates: localizationsDelegates ??
          [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
      supportedLocales: supportedLocales ?? S.delegate.supportedLocales,
      home: child,
    );
  }

  static void setupMockDependencies() {
    final getIt = GetIt.instance;

    // Always reset GetIt to avoid conflicts
    getIt.reset();

    // Create mock instances with proper return values
    final mockGetDeliveries = MockGetDeliveries();
    final mockGetReadyDeliveries = MockGetReadyDeliveries();
    final mockGetActiveDeliveries = MockGetActiveDeliveries();
    final mockGetCompletedDeliveries = MockGetCompletedDeliveries();
    final mockDeliveryManagementService = MockDeliveryManagementService();
    final mockDeliveryEventBus = MockDeliveryEventBus();

    // Setup mock return values
    when(() => mockGetDeliveries()).thenAnswer((_) async => []);
    when(() => mockGetReadyDeliveries()).thenAnswer((_) async => const PaginatedDeliveries(
          deliveries: [],
          currentPage: 1,
          totalPages: 1,
          totalItems: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        ));
    when(() => mockGetActiveDeliveries()).thenAnswer((_) async => const PaginatedDeliveries(
          deliveries: [],
          currentPage: 1,
          totalPages: 1,
          totalItems: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        ));
    when(() => mockGetCompletedDeliveries()).thenAnswer((_) async => const PaginatedDeliveries(
          deliveries: [],
          currentPage: 1,
          totalPages: 1,
          totalItems: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        ));
    when(() => mockDeliveryManagementService.startDelivery(any())).thenAnswer((_) async => Delivery(
          id: 'test',
          customerName: 'Test',
          address: 'Test Address',
          status: DeliveryStatus.inProgress,
          events: const [],
          createdAt: DateTime.now(),
        ));
    when(() => mockDeliveryManagementService.completeDelivery(any())).thenAnswer((_) async => Delivery(
          id: 'test',
          customerName: 'Test',
          address: 'Test Address',
          status: DeliveryStatus.completed,
          events: const [],
          createdAt: DateTime.now(),
        ));
    when(() => mockDeliveryEventBus.events).thenAnswer((_) => const Stream.empty());

    // Register mock dependencies
    getIt.registerLazySingleton<GetDeliveries>(() => mockGetDeliveries);
    getIt.registerLazySingleton<GetReadyDeliveries>(() => mockGetReadyDeliveries);
    getIt.registerLazySingleton<GetActiveDeliveries>(() => mockGetActiveDeliveries);
    getIt.registerLazySingleton<GetCompletedDeliveries>(() => mockGetCompletedDeliveries);
    getIt.registerLazySingleton<DeliveryManagementService>(() => mockDeliveryManagementService);
    getIt.registerLazySingleton<DeliveryEventBus>(() => mockDeliveryEventBus);
  }

  static void resetDependencies() {
    if (GetIt.instance.isRegistered<GetDeliveries>()) {
      GetIt.instance.reset();
    }
  }

  static Widget createScaffold({required Widget child}) {
    return Scaffold(
      body: child,
    );
  }

  static Widget createCard({required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
