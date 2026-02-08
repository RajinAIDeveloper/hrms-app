import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:root_app/models/profile/profile_model.dart';
import 'package:root_app/network/apis/profile_api.dart';
import 'package:root_app/network/dio_exceptions.dart';
import 'package:root_app/services/profile/profile_repository.dart';

class ProfileService implements ProfileRepository {
  final ProfileApi api;

  ProfileService({required this.api});

  @override
  Future<ProfileModel> userProfile(int id) async {
    try {
      final response = await api.getProfile(id);
      var result = ProfileModel.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }
}
