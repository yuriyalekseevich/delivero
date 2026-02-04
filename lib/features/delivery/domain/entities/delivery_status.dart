
enum DeliveryStatus {
  newDelivery('New'),
  inProgress('In Progress'),
  completed('Completed');

  const DeliveryStatus(this.displayName);
  final String displayName;
}
