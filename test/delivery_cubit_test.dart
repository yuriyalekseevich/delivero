import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:delivero/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('DeliveryCubit Tests', () {
    late DeliveryCubit deliveryCubit;

    setUp(() {
      TestHelpers.setupMockDependencies();
      deliveryCubit = DeliveryCubit();
    });

    tearDown(() {
      deliveryCubit.close();
      TestHelpers.resetDependencies();
    });

    test('initial state is DeliveryInitial', () {
      expect(deliveryCubit.state, equals(DeliveryInitial()));
    });

    group('loadDeliveries', () {
      blocTest<DeliveryCubit, DeliveryState>(
        'emits [DeliveryLoading, DeliveryLoaded] when loadDeliveries succeeds',
        build: () => deliveryCubit,
        act: (cubit) => cubit.loadDeliveries(),
        expect: () => [
          DeliveryLoading(),
          isA<DeliveryLoaded>(),
        ],
      );
    });

    group('startDelivery', () {
      test('startDelivery method exists', () {
        expect(() => deliveryCubit.startDelivery('DEL-001'), returnsNormally);
      });
    });

    group('completeDelivery', () {
      test('completeDelivery method exists', () {
        expect(() => deliveryCubit.completeDelivery('DEL-001'), returnsNormally);
      });
    });
  });
}
