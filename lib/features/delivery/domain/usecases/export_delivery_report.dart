import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../entities/delivery.dart';
import '../repositories/delivery_repository.dart';

@injectable
class ExportDeliveryReport {
  final DeliveryRepository _repository;

  const ExportDeliveryReport(this._repository);

  Future<void> call() async {
    final deliveries = await _repository.getDeliveries();
    final completedDeliveries = deliveries
        .where(
          (delivery) => delivery.status.name == 'completed',
        )
        .toList();

    if (completedDeliveries.isEmpty) {
      throw Exception('No completed deliveries to export');
    }

    final pdf = await _generatePDF(completedDeliveries);
    await _saveAndSharePDF(pdf);
  }

  Future<pw.Document> _generatePDF(List<Delivery> deliveries) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Delivery Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Generated on: ${DateTime.now().toString()}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              ...deliveries.map((delivery) => _buildDeliveryCard(delivery)),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildDeliveryCard(Delivery delivery) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Delivery ID: ${delivery.id}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Status: ${delivery.status.displayName}',
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.green,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text('Customer: ${delivery.customerName}'),
          pw.Text('Address: ${delivery.address}'),
          if (delivery.notes != null) pw.Text('Notes: ${delivery.notes}'),
          pw.SizedBox(height: 12),
          pw.Text(
            'Events:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          ...delivery.events.map((event) => pw.Padding(
                padding: const pw.EdgeInsets.only(left: 16, top: 4),
                child: pw.Text(
                  '${event.status.displayName} at ${event.timestamp.toString()} (${event.latitude}, ${event.longitude})',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _saveAndSharePDF(pw.Document pdf) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/delivery_report_${DateTime.now().millisecondsSinceEpoch}.pdf');

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Delivery Report',
    );
  }
}
