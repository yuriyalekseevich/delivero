import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';
import 'package:delivero/generated/l10n.dart';

@singleton
class DeliveryPDFExportService {
  Future<void> exportDeliveries(BuildContext context, List<Delivery> deliveries) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      if (deliveries.isEmpty) {
        Navigator.of(context).pop(); 
        _showErrorSnackBar(context, S.of(context).error);
        return;
      }

      final completedDeliveries = deliveries.where((delivery) => delivery.status == DeliveryStatus.completed).toList();

      if (completedDeliveries.isEmpty) {
        Navigator.of(context).pop(); 
        _showErrorSnackBar(context, 'No completed deliveries to export');
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context pdfContext) {
            return [
              _buildHeader('Delivery Report'),
              pw.SizedBox(height: 20),
              _buildSummary(completedDeliveries),
              pw.SizedBox(height: 20),
              _buildDeliveriesTable(completedDeliveries),
            ];
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/delivery_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        Navigator.of(context).pop(); 
        _showPDFSuccessDialog(context, file.path);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); 
        _showErrorSnackBar(context, 'Failed to export PDF: $e');
      }
    }
  }

  void _showPDFSuccessDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).pdfExportSuccessful),
          content: Text(S.of(context).pdfExportDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).close),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _showSocialShareOptions(context, filePath);
              },
              icon: const Icon(Icons.share),
              label: Text(S.of(context).share),
            ),
          ],
        );
      },
    );
  }

  void _showSocialShareOptions(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).shareDeliveryReport),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).chooseShareMethod),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    icon: Icons.email,
                    label: S.of(context).email,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).pop();
                      _shareViaEmail(context, filePath);
                    },
                  ),
                  _buildSocialButton(
                    icon: Icons.message,
                    label: 'WhatsApp',
                    color: Colors.green,
                    onTap: () {
                      Navigator.of(context).pop();
                      _shareViaWhatsApp(context, filePath);
                    },
                  ),
                  _buildSocialButton(
                    icon: Icons.telegram,
                    label: 'Telegram',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).pop();
                      _shareViaTelegram(context, filePath);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    icon: Icons.cloud_upload,
                    label: S.of(context).cloud,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.of(context).pop();
                      _shareViaCloud(context, filePath);
                    },
                  ),
                  _buildSocialButton(
                    icon: Icons.copy,
                    label: S.of(context).copyLink,
                    color: Colors.grey,
                    onTap: () {
                      Navigator.of(context).pop();
                      _copyToClipboard(context, filePath);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _shareViaEmail(BuildContext context, String filePath) {
    _sharePDF(context, filePath);
    _showInfoSnackBar(context, S.of(context).emailSharing);
  }

  void _shareViaWhatsApp(BuildContext context, String filePath) {
    _sharePDF(context, filePath);
    _showInfoSnackBar(context, S.of(context).whatsappSharing);
  }

  void _shareViaTelegram(BuildContext context, String filePath) {
    _sharePDF(context, filePath);
    _showInfoSnackBar(context, S.of(context).telegramSharing);
  }

  void _shareViaCloud(BuildContext context, String filePath) {
    _sharePDF(context, filePath);
    _showInfoSnackBar(context, S.of(context).cloudSharing);
  }

  void _copyToClipboard(BuildContext context, String filePath) {
    _showInfoSnackBar(context, S.of(context).linkCopied);
  }

  Future<void> _sharePDF(BuildContext context, String filePath) async {
    try {
      final file = XFile(filePath);
      await Share.shareXFiles([file], text: 'Delivery Report');
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to share PDF: $e');
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  pw.Widget _buildHeader(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Generated on: ${_formatDate(DateTime.now())}',
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              'Delivero',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummary(List<Delivery> deliveries) {
    final totalDeliveries = deliveries.length;
    final completedDeliveries = deliveries.where((d) => d.status == DeliveryStatus.completed).length;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Total Deliveries', totalDeliveries.toString()),
          _buildSummaryItem('Completed', completedDeliveries.toString()),
          _buildSummaryItem('Completion Rate',
              totalDeliveries > 0 ? '${(completedDeliveries / totalDeliveries * 100).toStringAsFixed(1)}%' : '0%'),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey600,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDeliveriesTable(List<Delivery> deliveries) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5), 
        1: const pw.FlexColumnWidth(2), 
        2: const pw.FlexColumnWidth(2), 
        3: const pw.FlexColumnWidth(2), 
        4: const pw.FlexColumnWidth(1.5), 
        5: const pw.FlexColumnWidth(1.5), 
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue100),
          children: [
            _buildTableCell('Delivery ID', isHeader: true),
            _buildTableCell('Customer', isHeader: true),
            _buildTableCell('Start', isHeader: true),
            _buildTableCell('End', isHeader: true),
            _buildTableCell('Duration', isHeader: true),
            _buildTableCell('Status', isHeader: true),
          ],
        ),
        ...deliveries
            .map((delivery) => pw.TableRow(
                  children: [
                    _buildTableCell(delivery.id),
                    _buildTableCell(delivery.customerName),
                    _buildTableCell('${_formatDateTime(delivery.createdAt)}\n${delivery.address}'),
                    _buildTableCell('${_formatDateTime(delivery.updatedAt)}\n${delivery.address}'),
                    _buildTableCell(_calculateDuration(delivery.createdAt, delivery.updatedAt)),
                    _buildTableCell(delivery.status.displayName),
                  ],
                ))
            .toList(),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.blue900 : PdfColors.black,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _calculateDuration(DateTime? startTime, DateTime? endTime) {
    if (startTime == null || endTime == null) return 'N/A';

    final duration = endTime.difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
