import 'package:delivero/core/di/injection.dart';
import 'package:delivero/core/services/delivery_pdf_export_service.dart';
import 'package:delivero/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';
import '../cubit/delivery_cubit.dart';
import '../widgets/delivery_status_chip.dart';
import 'delivery_maps_page.dart';

class DeliveryDetailPage extends StatelessWidget {
  final Delivery delivery;

  const DeliveryDetailPage({
    super.key,
    required this.delivery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).delivery),
        actions: [
          DeliveryStatusChip(status: delivery.status),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => _showDeliveryMap(context),
            tooltip: 'View on Map',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPDF(context),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            const SizedBox(height: 16),
            _buildEventsCard(context),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).delivery,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              Icons.person,
              S.of(context).customerName,
              delivery.customerName,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              Icons.location_on,
              S.of(context).address,
              delivery.address,
            ),
            if (delivery.notes != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                Icons.note,
                S.of(context).notes,
                delivery.notes!,
              ),
            ],
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              Icons.tag,
              'ID',
              delivery.id,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Events',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (delivery.events.isEmpty)
              Text(
                'No events yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              )
            else
              ...delivery.events.map((event) => _buildEventItem(context, event)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.status.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  '${event.timestamp.day}/${event.timestamp.month}/${event.timestamp.year} ${event.timestamp.hour}:${event.timestamp.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Text(
                  'Lat: ${event.latitude.toStringAsFixed(4)}, Lng: ${event.longitude.toStringAsFixed(4)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (delivery.status == DeliveryStatus.newDelivery)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _startDelivery(context),
              icon: const Icon(Icons.play_arrow),
              label: Text(S.of(context).startDelivery),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          )
        else if (delivery.status == DeliveryStatus.inProgress)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _completeDelivery(context),
              icon: const Icon(Icons.check),
              label: Text(S.of(context).completeDelivery),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
      ],
    );
  }

  void _startDelivery(BuildContext context) {
    context.read<DeliveryCubit>().startDelivery(delivery.id);
    Navigator.of(context).pop();
  }

  void _completeDelivery(BuildContext context) {
    context.read<DeliveryCubit>().completeDelivery(delivery.id);
    Navigator.of(context).pop();
  }

  void _showDeliveryMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeliveryMapsPage(
          deliveries: [delivery],
          title: '${delivery.customerName} - Map View',
        ),
      ),
    );
  }

  Future<void> _exportPDF(BuildContext context) async {
    final pdfService = getIt<DeliveryPDFExportService>();
    await pdfService.exportDeliveries(context, [delivery]);
  }
}
