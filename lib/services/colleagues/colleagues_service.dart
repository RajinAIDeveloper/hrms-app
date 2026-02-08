import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:root_app/models/colleagues/colleagues_response_model.dart';
import 'package:root_app/network/apis/colleagues_api.dart';
import 'package:root_app/network/dio_exceptions.dart';
import 'package:root_app/services/colleagues/colleagues_repository.dart';

class ColleaguesService implements ColleaguesRepository {
  final ColleaguesApi api;

  ColleaguesService({required this.api});

  @override
  Future<ColleaguesResponseModel> colleagues() async {
    try {
      final response = await api.getColleagues();
      var result =
          ColleaguesResponseModel.fromJson({'colleagues': response.data});
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }
}
