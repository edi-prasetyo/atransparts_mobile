import 'package:dio/dio.dart';

/// Exception thrown when the API returns validation errors (HTTP 422).
/// Contains a map of field name -> list of error messages.
class ValidationException extends DioException {
  final Map<String, List<String>> fieldErrors;
  final String? message;

  ValidationException({
    required this.fieldErrors,
    this.message,
    required RequestOptions requestOptions,
  }) : super(
          requestOptions: requestOptions,
          response: Response<Map<String, dynamic>>(
            requestOptions: requestOptions,
            statusCode: 422,
            data: {'errors': fieldErrors, 'message': message},
          ),
          type: DioExceptionType.badResponse,
          message: message ?? 'Validation failed',
        );

  /// Returns the first error message for the given field, or null if none.
  String? errorFor(String field) {
    final list = fieldErrors[field];
    if (list == null || list.isEmpty) return null;
    return list.first;
  }

  @override
  String toString() {
    if (message != null && message!.isNotEmpty) return message!;
    return fieldErrors.entries
        .map((e) => '${e.key}: ${e.value.join(', ')}')
        .join('; ');
  }
}