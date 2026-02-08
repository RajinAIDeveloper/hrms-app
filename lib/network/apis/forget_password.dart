
// class AuthService {
//   final Dio _dio = Dio();

//   Future<ForgotPasswordResponseModel> forgotPassword(
//       ForgotPasswordModel model) async {
//     try {
//       Response response = await _dio.post(
//         "/ControlPanel/Access/ForgetPassword", // Replace with your actual API endpoint
//         data: model.toJson(),
//       );

//       if (response.statusCode == 200) {
//         return ForgotPasswordResponseModel.fromJson(response.data);
//       } else {
//         return ForgotPasswordResponseModel(
//             status: false, message: "Failed to send request");
//       }
//     } catch (e) {
//       return ForgotPasswordResponseModel(
//           status: false, message: "Error: ${e.toString()}");
//     }
//   }
// }
// class AuthService {
//   final DioClient dioClient;
//   AuthenticationApi({required this.dioClient});

//   Future<Response> getAccessToken(SignInModel model) async {
//     try {
//       final response = await dioClient
//           .post("/controlpanel/access/LoginByMobile", data: model.toJson());
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
