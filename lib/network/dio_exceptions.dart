import 'package:dio/dio.dart';
import 'package:root_app/models/error/components.dart';

class DioExceptions implements Exception {
  late String _message;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        _message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        _message = "Connection timeout with Application server";
        break;
      case DioExceptionType.receiveTimeout:
        _message = "Receive timeout in connection with Application server";
        break;
      case DioExceptionType.sendTimeout:
        _message = "Send timeout in connection with Application server";
        break;
      case DioExceptionType.badResponse:
        _message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;

      case DioExceptionType.unknown:
      case DioExceptionType.connectionError:
        if (dioError.error.toString().contains("SocketException")) {
          _message = 'No Internet Connection. Please Try later.';
          break;
        }
        _message = "Unexpected error occurred. Please Try later.";
        break;
      default:
        _message = "Something went wrong. Please Try later.";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        var response = BadResponse.fromJson(error);
        return response.errors!.errorList
            .map((e) => e.message)
            .toList()
            .join(" | ");
      case 401:
        var response = BadResponse.fromJson(error);
        return response.messages!.join("\n");
      case 403:
        return 'Oops The request might be Forbidden';
      case 404:
        return 'The resource you are looking for Not found';
      case 500:
        return 'Oops something went wrong. Internal server error';
      case 502:
        return 'Oops something went wrong. Bad gateway';
      default:
        return 'Oops something went wrong. Please Try later..';
    }
  }

  @override
  String toString() => _message;
}
