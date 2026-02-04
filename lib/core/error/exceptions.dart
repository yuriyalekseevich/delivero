class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});
}

class LocationException implements Exception {
  final String message;

  const LocationException({required this.message});
}

class PermissionException implements Exception {
  final String message;

  const PermissionException({required this.message});
}

class ValidationException implements Exception {
  final String message;

  const ValidationException({required this.message});
}
