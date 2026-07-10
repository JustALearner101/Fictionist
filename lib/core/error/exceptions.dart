class DatabaseException implements Exception {
  final String message;
  final Object? originalError;
  DatabaseException(this.message, [this.originalError]);
  @override
  String toString() => 'DatabaseException: $message (${originalError ?? ''})';
}

class ValidationException implements Exception {
  final String message;
  final String? field;
  ValidationException(this.message, [this.field]);
  @override
  String toString() => 'ValidationException: $message (Field: ${field ?? 'none'})';
}

class NotFoundException implements Exception {
  final String resourceType;
  final String resourceId;
  NotFoundException(this.resourceType, this.resourceId);
  @override
  String toString() => 'NotFoundException: $resourceType with ID $resourceId not found';
}

class MappingException implements Exception {
  final String message;
  MappingException(this.message);
  @override
  String toString() => 'MappingException: $message';
}
