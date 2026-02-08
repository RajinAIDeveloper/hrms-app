import 'package:dio/dio.dart';
import 'package:root_app/models/auth/forget_password_model.dart';
import 'package:root_app/models/authentication/sign_in_model.dart';
import 'package:root_app/network/dio_client.dart';

class AuthenticationApi {
  final DioClient dioClient;
  AuthenticationApi({required this.dioClient});

  Future<Response> getAccessToken(SignInModel model) async {
    try {
      final response = await dioClient
          .post("/controlpanel/access/LoginByMobile", data: model.toJson());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Response> ForgetPasswordText(ForgotPasswordModel model) async {
  //   try {
  //     final response = await dioClient
  //         .post("/controlpanel/access/ForgetPassword", data: model.toJson());
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<Response> ForgetPasswordText(ForgotPasswordModel model) async {
    try {
      // Sending POST request with email data to the backend
      final response = await dioClient
          .post("/controlpanel/access/ForgetPassword", data: model.toJson());
      return response; // Returning the response
    } catch (e) {
      rethrow; // Rethrow exception if any
    }
  }

  Future<Response> verifyOTP(OTPVerificationRequestModel model) async {
    try {
      final response = await dioClient.post(
        "/controlpanel/access/ForgetPasswordVerification",
        data: model.toJson(),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        print(
            "DioException caught: ${e.response?.statusCode} - ${e.response?.data}");
      }
      rethrow; // rethrow the exception for further handling
    }
  }
}


// class UserApi {
// final DioClient dioClient;

// UserApi({required this.dioClient});

// Future<Response> addUserApi(String name, String job) async {
//   try {
//     final Response response = await dioClient.post(
//       Endpoints.users,
//       data: {
//         'name': name,
//         'job': job,
//       },
//     );
//     return response;
//   } catch (e) {
//     rethrow;
//   }
// }

// Future<Response> getUsersApi() async {
//   try {
//     final Response response = await dioClient.get(Endpoints.users);
//     return response;
//   } catch (e) {
//     rethrow;
//   }
// }

// Future<Response> updateUserApi(int id, String name, String job) async {
//   try {
//     final Response response = await dioClient.put(
//       Endpoints.users + '/$id',
//       data: {
//         'name': name,
//         'job': job,
//       },
//     );
//     return response;
//   } catch (e) {
//     rethrow;
//   }
// }

// Future<void> deleteUserApi(int id) async {
//   try {
//     await dioClient.delete(Endpoints.users + '/$id');
//   } catch (e) {
//     rethrow;
//   }
// }
// }
