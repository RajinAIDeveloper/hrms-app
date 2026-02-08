import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:root_app/models/authentication/components.dart';
import 'package:root_app/network/apis/authentication_api.dart';
import 'package:root_app/network/dio_exceptions.dart';
import 'package:root_app/services/authentication/authentication_repository.dart';

class AuthenticationService implements AuthenticationRepository {
  final AuthenticationApi api;

  AuthenticationService({required this.api});

  @override
  Future<SignInResponseModel> signIn(SignInModel model) async {
    try {
      final response = await api.getAccessToken(model);
      return SignInResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }
}

// class UserRepository {
//   final UserApi userApi;

//   UserRepository(this.userApi);

//   Future<List<UserModel>> getUsersRequested() async {
//     try {
//       final response = await userApi.getUsersApi();
//       final users = (response.data['data'] as List)
//           .map((e) => UserModel.fromJson(e))
//           .toList();
//       return users;
//     } on DioError catch (e) {
//       final errorMessage = DioExceptions.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }

//   Future<NewUser> addNewUserRequested(String name, String job) async {
//     try {
//       final response = await userApi.addUserApi(name, job);
//       return NewUser.fromJson(response.data);
//     } on DioError catch (e) {
//       final errorMessage = DioExceptions.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }

//   Future<NewUser> updateUserRequested(int id, String name, String job) async {
//     try {
//       final response = await userApi.updateUserApi(id, name, job);
//       return NewUser.fromJson(response.data);
//     } on DioError catch (e) {
//       final errorMessage = DioExceptions.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }

//   Future<void> deleteNewUserRequested(int id) async {
//     try {
//       await userApi.deleteUserApi(id);
//     } on DioError catch (e) {
//       final errorMessage = DioExceptions.fromDioError(e).toString();
//       throw errorMessage;
//     }
//   }
// }


