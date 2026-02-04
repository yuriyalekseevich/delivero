import 'package:delivero/core/error/exceptions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../models/delivery_model.dart';
import '../models/delivery_event_model.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';
import '../../domain/entities/delivery_filter.dart';
import '../../domain/entities/paginated_deliveries.dart';
import 'mock_delivery_data.dart';

abstract class DeliveryLocalDataSource {
  Future<List<Delivery>> getDeliveries();
  Future<Delivery?> getDeliveryById(String id);
  Future<Delivery> startDelivery(String id);
  Future<Delivery> completeDelivery(String id);
  Future<void> saveDelivery(Delivery delivery);
  Future<void> saveDeliveries(List<Delivery> deliveries);
  Stream<List<Delivery>> watchDeliveries();

  Future<PaginatedDeliveries> getDeliveriesPaginated(DeliveryFilter filter);
  Future<List<Delivery>> getDeliveriesByStatus(DeliveryStatus status);
  Future<List<Delivery>> searchDeliveries(String query);
  Stream<PaginatedDeliveries> watchDeliveriesPaginated(DeliveryFilter filter);

  Future<void> saveDeliveriesByStatus(DeliveryStatus status, List<Delivery> deliveries);
}

@LazySingleton(as: DeliveryLocalDataSource)
class DeliveryLocalDataSourceImpl implements DeliveryLocalDataSource {
  final Box<DeliveryModel> _deliveriesBox;
  final Uuid _uuid;

  DeliveryLocalDataSourceImpl(this._deliveriesBox, this._uuid);

  @override
  Future<List<Delivery>> getDeliveries() async {
    try {
      if (_deliveriesBox.isEmpty) {
        final mockDeliveries = MockDeliveryData.getMockDeliveries();
        await saveDeliveries(mockDeliveries);
        return mockDeliveries;
      }

      final deliveries = _deliveriesBox.values.map((model) => model.toEntity()).toList();
      return deliveries;
    } catch (e) {
      throw CacheException(message: 'Failed to get deliveries: $e');
    }
  }

  @override
  Future<Delivery?> getDeliveryById(String id) async {
    try {
      final deliveryModel = _deliveriesBox.values.firstWhere(
        (model) => model.id == id,
        orElse: () => throw Exception('Delivery not found'),
      );
      return deliveryModel.toEntity();
    } catch (e) {
      if (e.toString().contains('Delivery not found')) {
        return null;
      }
      throw CacheException(message: 'Failed to get delivery: $e');
    }
  }

  @override
  Future<Delivery> startDelivery(String id) async {
    try {
      final deliveryModel = _deliveriesBox.values.firstWhere(
        (model) => model.id == id,
        orElse: () => throw Exception('Delivery not found'),
      );

      if (deliveryModel.status != DeliveryStatus.newDelivery.name) {
        throw const ValidationException(message: 'Delivery is not in New status');
      }

      final now = DateTime.now();
      final event = DeliveryEventModel(
        id: _uuid.v4(),
        status: DeliveryStatus.inProgress.name,
        timestamp: now.toIso8601String(),
        latitude: 51.5074, 
        longitude: -0.1278,
      );

      final updatedModel = DeliveryModel(
        id: deliveryModel.id,
        customerName: deliveryModel.customerName,
        address: deliveryModel.address,
        notes: deliveryModel.notes,
        status: DeliveryStatus.inProgress.name,
        events: [...deliveryModel.events, event],
        createdAt: deliveryModel.createdAt,
        updatedAt: now.toIso8601String(),
      );

      await _deliveriesBox.put(deliveryModel.key, updatedModel);
      return updatedModel.toEntity();
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw CacheException(message: 'Failed to start delivery: $e');
    }
  }

  @override
  Future<Delivery> completeDelivery(String id) async {
    try {
      final deliveryModel = _deliveriesBox.values.firstWhere(
        (model) => model.id == id,
        orElse: () => throw Exception('Delivery not found'),
      );

      if (deliveryModel.status != DeliveryStatus.inProgress.name) {
        throw const ValidationException(message: 'Delivery is not in progress');
      }

      final now = DateTime.now();
      final event = DeliveryEventModel(
        id: _uuid.v4(),
        status: DeliveryStatus.completed.name,
        timestamp: now.toIso8601String(),
        latitude: 51.5074, 
        longitude: -0.1278,
      );

      final updatedModel = DeliveryModel(
        id: deliveryModel.id,
        customerName: deliveryModel.customerName,
        address: deliveryModel.address,
        notes: deliveryModel.notes,
        status: DeliveryStatus.completed.name,
        events: [...deliveryModel.events, event],
        createdAt: deliveryModel.createdAt,
        updatedAt: now.toIso8601String(),
      );

      await _deliveriesBox.put(deliveryModel.key, updatedModel);
      return updatedModel.toEntity();
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw CacheException(message: 'Failed to complete delivery: $e');
    }
  }

  @override
  Future<void> saveDelivery(Delivery delivery) async {
    try {
      final model = DeliveryModel.fromEntity(delivery);
      await _deliveriesBox.put(delivery.id, model);
    } catch (e) {
      throw CacheException(message: 'Failed to save delivery: $e');
    }
  }

  @override
  Future<void> saveDeliveries(List<Delivery> deliveries) async {
    try {
      for (final delivery in deliveries) {
        final model = DeliveryModel.fromEntity(delivery);
        await _deliveriesBox.put(delivery.id, model);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save deliveries: $e');
    }
  }

  @override
  Stream<List<Delivery>> watchDeliveries() {
    return _deliveriesBox.watch().map((_) {
      return _deliveriesBox.values.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<PaginatedDeliveries> getDeliveriesPaginated(DeliveryFilter filter) async {
    try {
      final allDeliveries = _deliveriesBox.values.map((model) => model.toEntity()).toList();

      var filteredDeliveries = _applyFilters(allDeliveries, filter);

      filteredDeliveries = _applySorting(filteredDeliveries, filter);

      final totalItems = filteredDeliveries.length;
      final totalPages = (totalItems / filter.limit).ceil();
      final startIndex = (filter.page - 1) * filter.limit;
      final endIndex = (startIndex + filter.limit).clamp(0, totalItems);

      final paginatedDeliveries = filteredDeliveries.sublist(
        startIndex,
        endIndex,
      );

      return PaginatedDeliveries(
        deliveries: paginatedDeliveries,
        currentPage: filter.page,
        totalPages: totalPages,
        totalItems: totalItems,
        hasNextPage: filter.page < totalPages,
        hasPreviousPage: filter.page > 1,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to get paginated deliveries: $e');
    }
  }

  @override
  Future<List<Delivery>> getDeliveriesByStatus(DeliveryStatus status) async {
    try {
      return _deliveriesBox.values
          .map((model) => model.toEntity())
          .where((delivery) => delivery.status == status)
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get deliveries by status: $e');
    }
  }

  @override
  Future<List<Delivery>> searchDeliveries(String query) async {
    try {
      final lowerQuery = query.toLowerCase();
      return _deliveriesBox.values
          .map((model) => model.toEntity())
          .where((delivery) =>
              delivery.customerName.toLowerCase().contains(lowerQuery) ||
              delivery.address.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to search deliveries: $e');
    }
  }

  @override
  Stream<PaginatedDeliveries> watchDeliveriesPaginated(DeliveryFilter filter) {
    return _deliveriesBox.watch().asyncMap((_) async {
      return await getDeliveriesPaginated(filter);
    });
  }

  List<Delivery> _applyFilters(List<Delivery> deliveries, DeliveryFilter filter) {
    var filtered = deliveries;

    if (filter.status != null) {
      filtered = filtered.where((d) => d.status == filter.status).toList();
    }

    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      filtered = filtered
          .where((d) => d.customerName.toLowerCase().contains(query) || d.address.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  List<Delivery> _applySorting(List<Delivery> deliveries, DeliveryFilter filter) {
    if (filter.sortBy == null) return deliveries;

    deliveries.sort((a, b) {
      int comparison = 0;

      switch (filter.sortBy) {
        case 'createdAt':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case 'updatedAt':
          final aUpdated = a.updatedAt ?? a.createdAt;
          final bUpdated = b.updatedAt ?? b.createdAt;
          comparison = aUpdated.compareTo(bUpdated);
          break;
        case 'customerName':
          comparison = a.customerName.compareTo(b.customerName);
          break;
        case 'address':
          comparison = a.address.compareTo(b.address);
          break;
        default:
          return 0;
      }

      return filter.ascending ? comparison : -comparison;
    });

    return deliveries;
  }

  @override
  Future<void> saveDeliveriesByStatus(DeliveryStatus status, List<Delivery> deliveries) async {
    try {
      final models = deliveries.map((delivery) => DeliveryModel.fromEntity(delivery)).toList();

      for (final model in models) {
        await _deliveriesBox.put(model.id, model);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save deliveries by status: $e');
    }
  }
}
