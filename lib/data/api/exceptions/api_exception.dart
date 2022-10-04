class ApiException implements Exception {
  final int? statusCode;
  final String? status;
  final String? message;
  final String? cod;
  final dynamic error;

  ApiException(
      {this.statusCode, this.status, this.message, this.error, this.cod});
}
