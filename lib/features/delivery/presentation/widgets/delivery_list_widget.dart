import 'package:delivero/generated/l10n.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';
import 'delivery_card.dart';

class DeliveryListWidget extends StatelessWidget {
  final List<Delivery> deliveries;

  const DeliveryListWidget({
    super.key,
    required this.deliveries,
  });

  @override
  Widget build(BuildContext context) {
    final readyToTake = deliveries.where((d) => d.status == DeliveryStatus.newDelivery).toList();
    final inProgress = deliveries.where((d) => d.status == DeliveryStatus.inProgress).toList();
    final completed = deliveries.where((d) => d.status == DeliveryStatus.completed).toList();

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                text: S.of(context).readyToTake,
                icon: const Icon(Icons.assignment),
              ),
              Tab(
                text: S.of(context).active,
                icon: const Icon(Icons.local_shipping),
              ),
              Tab(
                text: S.of(context).completed,
                icon: const Icon(Icons.check_circle),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildDeliveryList(context, readyToTake),
                _buildDeliveryList(context, inProgress),
                _buildDeliveryList(context, completed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryList(BuildContext context, List<Delivery> deliveries) {
    if (deliveries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No deliveries found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: deliveries.length,
      itemBuilder: (context, index) {
        final delivery = deliveries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DeliveryCard(delivery: delivery),
        );
      },
    );
  }
}
