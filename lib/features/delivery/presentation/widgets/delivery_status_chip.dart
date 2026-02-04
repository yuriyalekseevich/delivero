import 'package:delivero/generated/l10n.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/delivery_status.dart';

class DeliveryStatusChip extends StatelessWidget {
  final DeliveryStatus status;

  const DeliveryStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case DeliveryStatus.newDelivery:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        text = S.of(context).newDelivery;
        break;
      case DeliveryStatus.inProgress:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        text = S.of(context).inProgress;
        break;
      case DeliveryStatus.completed:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        text = S.of(context).completed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
