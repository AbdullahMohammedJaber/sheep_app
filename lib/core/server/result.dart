 import 'package:sheep/util/constants/app_strings.dart';
 
enum RequestStatus { success, failed, noInternet }

class ApiResult<T> {
  final RequestStatus status;
  final T? data;
  final dynamic message;
  final int? statusCode;

  const ApiResult._({
    required this.status,
    this.data,
    this.message,
    this.statusCode,
  });

  /// =======================
  /// Success
  /// =======================
  factory ApiResult.success(T data, {int? statusCode, String? message}) {
    return ApiResult._(
      status: RequestStatus.success,
      data: data,
      statusCode: statusCode,
      message: message,
    );
  }

  /// =======================
  /// Failed (Server/API)
  /// =======================
  factory ApiResult.failed({
    dynamic  message,
    int? statusCode,
    dynamic data,
  }) {
    return ApiResult._(
      status: RequestStatus.failed,
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }

  /// =======================
  /// No Internet
  /// =======================
  factory ApiResult.noInternet({String? message}) {
    return ApiResult._(
      status: RequestStatus.noInternet,
      message: message,
    );
  }

  /// =======================
  /// Helpers
  /// =======================
  bool get isSuccess => status == RequestStatus.success;

  bool get isFailed => status == RequestStatus.failed;

  bool get isNoInternet => status == RequestStatus.noInternet;

  /// =======================
  /// Normalize Message
  /// =======================
  String get messageAsString {
    if (message == null) return '';

    // String
    if (message is String) {
      return message;
    }

    // List
    if (message is List) {
      return (message as List)
          .map((e) => e.toString())
          .join('\n');
    }

 
    if (message is Map) {
      final values = (message as Map).values;

      return values
          .expand((e) => e is List ? e : [e])
          .map((e) => e.toString())
          .join('\n');
    }

 
    return message.toString();
  }

  /// =======================
  /// Handle Result
  /// =======================
  void handle({
    required void Function(T data) onSuccess,
    void Function(String message ,  int ? code )? onFailed,
    void Function()? onNoInternet,
  }) {
    if (isSuccess && data != null) {
      onSuccess(data as T);
    } else if (isFailed) {
      if (onFailed != null) {
        onFailed(
          messageAsString.isNotEmpty
              ? messageAsString
              : AppStrings.noInternet,
              statusCode,
        );
      }
    } else if (isNoInternet) {
      if (onNoInternet != null) {
        onNoInternet();
      }
    }
  }
}