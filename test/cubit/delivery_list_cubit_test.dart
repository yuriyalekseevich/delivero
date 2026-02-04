import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:delivero/features/delivery/presentation/cubit/delivery_list_cubit.dart';
import 'package:delivero/core/services/delivery_event_bus.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/test_helpers.dart';

class MockDeliveryEventBus extends Mock implements DeliveryEventBus {}

void main() {
  group('DeliveryListCubit Tests', () {
    late DeliveryListCubit cubit;

    setUp(() {
      TestHelpers.setupMockDependencies();
      cubit = DeliveryListCubit();
    });

    tearDown(() {
      cubit.close();
      TestHelpers.resetDependencies();
    });

    test('initial state is correct', () {
      expect(cubit.state, isA<DeliveryListInitial>());
    });

    group('loadReadyDeliveries', () {
      blocTest<DeliveryListCubit, DeliveryListState>(
        'emits [DeliveryListLoading, DeliveryListLoaded] when loadReadyDeliveries succeeds',
        build: () => cubit,
        act: (cubit) => cubit.loadReadyDeliveries(),
        expect: () => [
          isA<DeliveryListLoading>(),
          isA<DeliveryListLoaded>(),
        ],
      );
    });
  });
}
