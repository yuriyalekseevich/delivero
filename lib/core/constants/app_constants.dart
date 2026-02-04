class AppConstants {
  static const String baseUrl = 'https://api.delivero.com';
  static const String deliveryApiUrl = 'https://api.delivero.com/v1/deliveries';
  static const String paymentApiUrl = 'https://api.delivero.com/v1/payments';
  static const String groceryApiUrl = 'https://api.delivero.com/v1/groceries';

  static const String deliveriesBox = 'deliveries';
  static const String offlineQueueBox = 'offline_queue';
  static const String settingsBox = 'settings';
  static const String debugLogsBox = 'debug_logs';

  static const int debugScreenTapCount = 10;

  static const double defaultLatitude = 51.5074;
  static const double defaultLongitude = -0.1278;

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration locationTimeout = Duration(seconds: 10);
}
