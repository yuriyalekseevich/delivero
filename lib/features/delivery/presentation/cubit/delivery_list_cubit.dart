import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:delivero/core/di/injection.dart';
import 'package:delivero/core/error/failures.dart';
import 'package:delivero/core/services/delivery_management_service.dart';
import 'package:delivero/core/services/delivery_event_bus.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';
import '../../domain/entities/delivery_filter.dart';
import '../../domain/entities/paginated_deliveries.dart';
import '../../domain/usecases/get_ready_deliveries.dart';
import '../../domain/usecases/get_active_deliveries.dart';
import '../../domain/usecases/get_completed_deliveries.dart';

part 'delivery_list_state.dart';

class DeliveryListCubit extends Cubit<DeliveryListState> {
  DeliveryListCubit() : super(DeliveryListInitial()) {
    _setupEventBusListener();
  }

  DeliveryFilter _currentFilter = const DeliveryFilter();
  String _currentTab = 'ready';
  StreamSubscription<DeliveryEventData>? _eventSubscription;

  Future<void> loadReadyDeliveries({int page = 1, String? searchQuery}) async {
    emit(DeliveryListLoading());

    try {
      final getReadyDeliveries = getIt<GetReadyDeliveries>();
      final result = await getReadyDeliveries(
        page: page,
        searchQuery: searchQuery,
      );

      _currentFilter = _currentFilter.copyWith(
        status: DeliveryStatus.newDelivery,
        page: page,
        searchQuery: searchQuery,
      );
      _currentTab = 'ready';

      emit(DeliveryListLoaded(
        deliveries: result.deliveries,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        hasNextPage: result.hasNextPage,
        hasPreviousPage: result.hasPreviousPage,
        tab: 'ready',
      ));
    } on ServerFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on NetworkFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on CacheFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    }
  }

  Future<void> loadActiveDeliveries({int page = 1, String? searchQuery}) async {
    emit(DeliveryListLoading());

    try {
      final getActiveDeliveries = getIt<GetActiveDeliveries>();
      final result = await getActiveDeliveries(
        page: page,
        searchQuery: searchQuery,
      );

      _currentFilter = _currentFilter.copyWith(
        status: DeliveryStatus.inProgress,
        page: page,
        searchQuery: searchQuery,
      );
      _currentTab = 'active';

      emit(DeliveryListLoaded(
        deliveries: result.deliveries,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        hasNextPage: result.hasNextPage,
        hasPreviousPage: result.hasPreviousPage,
        tab: 'active',
      ));
    } on ServerFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on NetworkFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on CacheFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    }
  }

  Future<void> loadCompletedDeliveries({int page = 1, String? searchQuery}) async {
    emit(DeliveryListLoading());

    try {
      final getCompletedDeliveries = getIt<GetCompletedDeliveries>();
      final result = await getCompletedDeliveries(
        page: page,
        searchQuery: searchQuery,
      );

      _currentFilter = _currentFilter.copyWith(
        status: DeliveryStatus.completed,
        page: page,
        searchQuery: searchQuery,
      );
      _currentTab = 'completed';

      emit(DeliveryListLoaded(
        deliveries: result.deliveries,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        hasNextPage: result.hasNextPage,
        hasPreviousPage: result.hasPreviousPage,
        tab: 'completed',
      ));
    } on ServerFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on NetworkFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on CacheFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    }
  }

  Future<void> startDelivery(String deliveryId) async {
    try {
      final deliveryManagementService = getIt<DeliveryManagementService>();
      final updatedDelivery = await deliveryManagementService.startDelivery(deliveryId);

      if (state is DeliveryListLoaded) {
        final currentState = state as DeliveryListLoaded;
        final updatedDeliveries = currentState.deliveries.map((delivery) {
          return delivery.id == deliveryId ? updatedDelivery : delivery;
        }).toList();

        emit(DeliveryListLoaded(
          deliveries: updatedDeliveries,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          hasNextPage: currentState.hasNextPage,
          hasPreviousPage: currentState.hasPreviousPage,
          tab: currentState.tab,
        ));
      } else if (state is DeliveryListPaginationLoading) {
        final currentState = state as DeliveryListPaginationLoading;
        final updatedDeliveries = currentState.deliveries.map((delivery) {
          return delivery.id == deliveryId ? updatedDelivery : delivery;
        }).toList();

        emit(DeliveryListPaginationLoading(
          deliveries: updatedDeliveries,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          hasNextPage: currentState.hasNextPage,
          hasPreviousPage: currentState.hasPreviousPage,
          tab: currentState.tab,
        ));
      }
    } on ServerFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on NetworkFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on CacheFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on ValidationFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    }
  }

  Future<void> completeDelivery(String deliveryId) async {
    try {
      final deliveryManagementService = getIt<DeliveryManagementService>();
      final updatedDelivery = await deliveryManagementService.completeDelivery(deliveryId);

      if (state is DeliveryListLoaded) {
        final currentState = state as DeliveryListLoaded;
        final updatedDeliveries = currentState.deliveries.map((delivery) {
          return delivery.id == deliveryId ? updatedDelivery : delivery;
        }).toList();

        emit(DeliveryListLoaded(
          deliveries: updatedDeliveries,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          hasNextPage: currentState.hasNextPage,
          hasPreviousPage: currentState.hasPreviousPage,
          tab: currentState.tab,
        ));
      } else if (state is DeliveryListPaginationLoading) {
        final currentState = state as DeliveryListPaginationLoading;
        final updatedDeliveries = currentState.deliveries.map((delivery) {
          return delivery.id == deliveryId ? updatedDelivery : delivery;
        }).toList();

        emit(DeliveryListPaginationLoading(
          deliveries: updatedDeliveries,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          hasNextPage: currentState.hasNextPage,
          hasPreviousPage: currentState.hasPreviousPage,
          tab: currentState.tab,
        ));
      }
    } on ServerFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on NetworkFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on CacheFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    } on ValidationFailure catch (e) {
      emit(DeliveryListError(message: e.message));
    }
  }

  Future<void> searchDeliveries(String query) async {
    switch (_currentTab) {
      case 'ready':
        await loadReadyDeliveries(searchQuery: query);
        break;
      case 'active':
        await loadActiveDeliveries(searchQuery: query);
        break;
      case 'completed':
        await loadCompletedDeliveries(searchQuery: query);
        break;
    }
  }

  Future<void> loadNextPage() async {
    if (state is DeliveryListLoaded) {
      final currentState = state as DeliveryListLoaded;
      if (currentState.hasNextPage) {
        emit(DeliveryListPaginationLoading(
          deliveries: currentState.deliveries,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          hasNextPage: currentState.hasNextPage,
          hasPreviousPage: currentState.hasPreviousPage,
          tab: currentState.tab,
        ));

        try {
          switch (_currentTab) {
            case 'ready':
              await _loadNextPageForTab('ready', currentState.currentPage + 1);
              break;
            case 'active':
              await _loadNextPageForTab('active', currentState.currentPage + 1);
              break;
            case 'completed':
              await _loadNextPageForTab('completed', currentState.currentPage + 1);
              break;
          }
        } on ServerFailure catch (e) {
          emit(DeliveryListError(message: e.message));
        } on NetworkFailure catch (e) {
          emit(DeliveryListError(message: e.message));
        } on CacheFailure catch (e) {
          emit(DeliveryListError(message: e.message));
        }
      }
    }
  }

  Future<void> _loadNextPageForTab(String tab, int page) async {
    switch (tab) {
      case 'ready':
        final getReadyDeliveries = getIt<GetReadyDeliveries>();
        final result = await getReadyDeliveries(
          page: page,
          searchQuery: _currentFilter.searchQuery,
        );
        _appendDeliveries(result);
        break;
      case 'active':
        final getActiveDeliveries = getIt<GetActiveDeliveries>();
        final result = await getActiveDeliveries(
          page: page,
          searchQuery: _currentFilter.searchQuery,
        );
        _appendDeliveries(result);
        break;
      case 'completed':
        final getCompletedDeliveries = getIt<GetCompletedDeliveries>();
        final result = await getCompletedDeliveries(
          page: page,
          searchQuery: _currentFilter.searchQuery,
        );
        _appendDeliveries(result);
        break;
    }
  }

  void _appendDeliveries(PaginatedDeliveries result) {
    if (state is DeliveryListPaginationLoading) {
      final currentState = state as DeliveryListPaginationLoading;
      final allDeliveries = [...currentState.deliveries, ...result.deliveries];

      emit(DeliveryListLoaded(
        deliveries: allDeliveries,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        hasNextPage: result.hasNextPage,
        hasPreviousPage: result.hasPreviousPage,
        tab: currentState.tab,
      ));
    }
  }

  bool _shouldRemoveFromCurrentTab(String currentTab, DeliveryStatus newStatus) {
    switch (currentTab) {
      case 'ready':
        return newStatus != DeliveryStatus.newDelivery;
      case 'active':
        return newStatus != DeliveryStatus.inProgress;
      case 'completed':
        return newStatus != DeliveryStatus.completed;
      default:
        return false;
    }
  }

  void _setupEventBusListener() {
    final eventBus = getIt<DeliveryEventBus>();
    _eventSubscription = eventBus.events.listen((eventData) {
      _handleDeliveryEvent(eventData);
    });
  }

  void _handleDeliveryEvent(DeliveryEventData eventData) {
    if (state is DeliveryListLoaded) {
      final currentState = state as DeliveryListLoaded;

      switch (eventData.eventType) {
        case DeliveryEventType.statusChanged:
          _handleStatusChange(eventData, currentState);
          break;
        case DeliveryEventType.deliveryUpdated:
          _handleDeliveryUpdate(eventData, currentState);
          break;
        case DeliveryEventType.deliveryRemoved:
          _handleDeliveryRemoval(eventData, currentState);
          break;
      }
    } else if (state is DeliveryListPaginationLoading) {
      final currentState = state as DeliveryListPaginationLoading;

      switch (eventData.eventType) {
        case DeliveryEventType.statusChanged:
          _handleStatusChangePagination(eventData, currentState);
          break;
        case DeliveryEventType.deliveryUpdated:
          _handleDeliveryUpdatePagination(eventData, currentState);
          break;
        case DeliveryEventType.deliveryRemoved:
          _handleDeliveryRemovalPagination(eventData, currentState);
          break;
      }
    }
  }

  void _handleStatusChange(DeliveryEventData eventData, DeliveryListLoaded currentState) {
    if (_shouldRemoveFromCurrentTab(currentState.tab, eventData.newStatus)) {
      final updatedDeliveries =
          currentState.deliveries.where((delivery) => delivery.id != eventData.deliveryId).toList();

      emit(DeliveryListLoaded(
        deliveries: updatedDeliveries,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        hasNextPage: currentState.hasNextPage,
        hasPreviousPage: currentState.hasPreviousPage,
        tab: currentState.tab,
      ));
    } else if (eventData.delivery != null) {
      final updatedDeliveries = currentState.deliveries.map((delivery) {
        return delivery.id == eventData.deliveryId ? eventData.delivery! : delivery;
      }).toList();

      emit(DeliveryListLoaded(
        deliveries: updatedDeliveries,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        hasNextPage: currentState.hasNextPage,
        hasPreviousPage: currentState.hasPreviousPage,
        tab: currentState.tab,
      ));
    }
  }

  void _handleStatusChangePagination(DeliveryEventData eventData, DeliveryListPaginationLoading currentState) {
    if (_shouldRemoveFromCurrentTab(currentState.tab, eventData.newStatus)) {
      final updatedDeliveries =
          currentState.deliveries.where((delivery) => delivery.id != eventData.deliveryId).toList();

      emit(DeliveryListPaginationLoading(
        deliveries: updatedDeliveries,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        hasNextPage: currentState.hasNextPage,
        hasPreviousPage: currentState.hasPreviousPage,
        tab: currentState.tab,
      ));
    } else if (eventData.delivery != null) {
      final updatedDeliveries = currentState.deliveries.map((delivery) {
        return delivery.id == eventData.deliveryId ? eventData.delivery! : delivery;
      }).toList();

      emit(DeliveryListPaginationLoading(
        deliveries: updatedDeliveries,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        hasNextPage: currentState.hasNextPage,
        hasPreviousPage: currentState.hasPreviousPage,
        tab: currentState.tab,
      ));
    }
  }

  void _handleDeliveryUpdate(DeliveryEventData eventData, DeliveryListLoaded currentState) {
    if (eventData.delivery != null) {
      final updatedDeliveries = currentState.deliveries.map((delivery) {
        return delivery.id == eventData.deliveryId ? eventData.delivery! : delivery;
      }).toList();

      emit(DeliveryListLoaded(
        deliveries: updatedDeliveries,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        hasNextPage: currentState.hasNextPage,
        hasPreviousPage: currentState.hasPreviousPage,
        tab: currentState.tab,
      ));
    }
  }

  void _handleDeliveryUpdatePagination(DeliveryEventData eventData, DeliveryListPaginationLoading currentState) {
    if (eventData.delivery != null) {
      final updatedDeliveries = currentState.deliveries.map((delivery) {
        return delivery.id == eventData.deliveryId ? eventData.delivery! : delivery;
      }).toList();

      emit(DeliveryListPaginationLoading(
        deliveries: updatedDeliveries,
        currentPage: currentState.currentPage,
        totalPages: currentState.totalPages,
        hasNextPage: currentState.hasNextPage,
        hasPreviousPage: currentState.hasPreviousPage,
        tab: currentState.tab,
      ));
    }
  }

  void _handleDeliveryRemoval(DeliveryEventData eventData, DeliveryListLoaded currentState) {
    final updatedDeliveries = currentState.deliveries.where((delivery) => delivery.id != eventData.deliveryId).toList();

    emit(DeliveryListLoaded(
      deliveries: updatedDeliveries,
      currentPage: currentState.currentPage,
      totalPages: currentState.totalPages,
      hasNextPage: currentState.hasNextPage,
      hasPreviousPage: currentState.hasPreviousPage,
      tab: currentState.tab,
    ));
  }

  void _handleDeliveryRemovalPagination(DeliveryEventData eventData, DeliveryListPaginationLoading currentState) {
    final updatedDeliveries = currentState.deliveries.where((delivery) => delivery.id != eventData.deliveryId).toList();

    emit(DeliveryListPaginationLoading(
      deliveries: updatedDeliveries,
      currentPage: currentState.currentPage,
      totalPages: currentState.totalPages,
      hasNextPage: currentState.hasNextPage,
      hasPreviousPage: currentState.hasPreviousPage,
      tab: currentState.tab,
    ));
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}
