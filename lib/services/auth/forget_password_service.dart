import 'package:root_app/models/auth/forget_password_model.dart';
import 'package:root_app/network/apis/authentication_api.dart';

class ForgotPasswordRepository {
  final AuthenticationApi authenticationApi;

  ForgotPasswordRepository({required this.authenticationApi});

  // Future<String> requestForgotPassword(String email) async {
  //   ForgotPasswordModel model = ForgotPasswordModel(email: email);
  //   try {
  //     final response = await authenticationApi.ForgetPasswordText(model);

  //     if (response.statusCode == 200) {
  //       // You can process the response if needed, or return a success message
  //       return "OTP sent successfully to $email";
  //     } else {
  //       return "Failed to send OTP: ${response.data['message'] ?? 'Unknown error'}";
  //     }
  //   } catch (e) {
  //     return "Error: ${e.toString()}";
  //   }
  // }
  String storedToken = "";
  // Future<String> requestForgotPassword(String email) async {
  //   ForgotPasswordModel model = ForgotPasswordModel(email: email);
  //   try {
  //     final response = await authenticationApi.ForgetPasswordText(model);

  //     if (response.statusCode == 200) {
  //       // Successfully sent OTP, return success message
  //       var responseData = response.data;

  //       if (responseData.containsKey('token')) {
  //         // ✅ Ensure UI updates with the new token
  //         storedToken = responseData['token'];
  //       }

  //       return "OTP sent successfully to $email";
  //     } else {
  //       // Failed to send OTP, return the error message from backend response
  //       return "Failed to send OTP: ${response.data['ErrorMsg'] ?? 'Unknown error'}";
  //     }
  //   } catch (e) {
  //     // Catch any exceptions and return an error message
  //     return "Error: ${e.toString()}";
  //   }
  // }

  // Future<String> verifyOTP(String email, String otp, String token) async {
  //   OTPVerificationRequestModel model = OTPVerificationRequestModel(
  //     email: email,
  //     otp: otp,
  //     token: token,
  //   );
  //   try {
  //     final response = await authenticationApi.verifyOTP(model);

  //     if (response.statusCode == 200) {
  //       return "OTP verified successfully.";
  //     } else {
  //       return "Failed to verify OTP: ${response.data['message'] ?? 'Unknown error'}";
  //     }
  //   } catch (e) {
  //     return "Error: ${e.toString()}";
  //   }
  // }

  Future<Map<String, dynamic>> requestForgotPassword(String email) async {
    ForgotPasswordModel model = ForgotPasswordModel(email: email);
    try {
      final response = await authenticationApi.ForgetPasswordText(model);

      if (response.statusCode == 200) {
        var responseData = response.data; // ✅ Ensure responseData is a Map
        return responseData; // ✅ Return the full response
      } else {
        return {"msg": "Failed to send OTP", "token": ""};
      }
    } catch (e) {
      return {"msg": "Error: ${e.toString()}", "token": ""};
    }
  }

  // Future<String> verifyOTP(String email, String otp, String token) async {
  //   // if (storedToken == null) {
  //   //   return "Error: No token found. Please request OTP again.";
  //   // }

  //   try {
  //     OTPVerificationRequestModel otpRequest = OTPVerificationRequestModel(
  //       email: email,
  //       otp: otp,
  //       token: storedToken, // Ensure token is not null
  //     );

  //     final response = await authenticationApi
  //         .verifyOTP(otpRequest.toJson() as OTPVerificationRequestModel);

  //     if (response.statusCode == 200) {
  //       return "OTP verified successfully.";
  //     } else {
  //       return "Failed to verify OTP: ${response.data['message'] ?? 'Unknown error'}";
  //     }
  //   } catch (e) {
  //     return "Error: ${e.toString()}";
  //   }
  // }
  // Future<String> verifyOTP(String email, String otp, String token) async {
  //   try {
  //     OTPVerificationRequestModel otpRequest = OTPVerificationRequestModel(
  //       email: email,
  //       otp: otp,
  //       token: token, // Ensure token is passed correctly
  //     );

  //     // Pass the Map directly instead of casting it back into the model
  //     final response = await authenticationApi.verifyOTP(otpRequest); // ✅

  //     if (response.statusCode == 200) {
  //       return "OTP verified successfully.";
  //     } else {
  //       return "Failed to verify OTP: ${response.data['message'] ?? 'Unknown error'}";
  //     }
  //   } catch (e) {
  //     return "Error: ${e.toString()}";
  //   }
  // }

  Future<Map<String, dynamic>> verifyOTP(
      String email, String otp, String token) async {
    try {
      OTPVerificationRequestModel otpRequest = OTPVerificationRequestModel(
        email: email,
        otp: otp,
        token: token, // Ensure token is passed correctly
      );

      final response = await authenticationApi.verifyOTP(otpRequest);

      if (response.statusCode == 200) {
        return response.data; // ✅ Return the full response as a Map
      } else {
        return {
          "status": false,
          "msg": response.data['message'] ?? "Failed to verify OTP",
        };
      }
    } catch (e) {
      return {"status": false, "msg": "Error: ${e.toString()}"};
    }
  }
}

class OTPVerificationRepository {
  final AuthenticationApi authenticationApi;

  OTPVerificationRepository({required this.authenticationApi});

  Future<String> verifyOTP(String email, String otp, String token) async {
    OTPVerificationRequestModel model = OTPVerificationRequestModel(
      email: email,
      otp: otp,
      token: token,
    );
    try {
      final response = await authenticationApi.verifyOTP(model);

      if (response.statusCode == 200) {
        return "OTP verified successfully.";
      } else {
        return "Failed to verify OTP: ${response.data['message'] ?? 'Unknown error'}";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
