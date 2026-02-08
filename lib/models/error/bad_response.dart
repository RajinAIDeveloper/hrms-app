// ignore: unused_import
import 'package:flutter/foundation.dart';

class BadResponse {
  String? type;
  String? title;
  int? status;
  String? detail;
  String? instance;
  Errors? errors;
  List<String>? messages;
  String? source;
  String? exception;
  String? errorId;
  String? supportMessage;
  int? statusCode;

  BadResponse(
      {this.type,
      this.title,
      this.status,
      this.detail,
      this.instance,
      this.errors,
      this.messages,
      this.source,
      this.exception,
      this.errorId,
      this.supportMessage,
      this.statusCode});

  BadResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    status = json['status'];
    detail = json['detail'];
    instance = json['instance'];
    errors = (json['errors'] != null
        ? Errors.fromJson({'errors': json['errors']})
        : null);

    messages = json['messages'] != null ? json['messages']!.cast<String>() : [];
    source = json['source'];
    exception = json['exception'];
    errorId = json['errorId'];
    supportMessage = json['supportMessage'];
    statusCode = json['statusCode'];
  }
}

class Errors {
  List<ErrorProperty> errorList = <ErrorProperty>[];

  Errors({errorList});

  Errors.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errorList = <ErrorProperty>[];
      var errors = json['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        var propName = key.toString();
        var errMsg = value.cast<String>().join('').toString();
        // debugPrint(propName);
        // debugPrint(errMsg);
        errorList.add(ErrorProperty(name: propName, message: errMsg));
      });
    }
  }
}

class ErrorProperty {
  String name = '-';
  String message = '-';
  ErrorProperty({required this.name, required this.message});
}
