import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/models/auth/forget_password_model.dart';
import 'package:root_app/network/apis/authentication_api.dart';
import 'package:root_app/network/dio_client.dart';
import 'package:root_app/routes/routing_constants.dart';
import 'package:root_app/services/auth/forget_password_service.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isOtpSent = false; // State variable to track OTP sent status
  String storedToken = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController =
      TextEditingController(); // Controller for OTP input

  void sendOtp() {
    if (emailController.text.isEmpty) {
      // Show validation message if email is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call the handleForgotPassword function when email is valid
    handleForgotPassword(emailController.text);

    setState(() {
      isOtpSent = true; // Set to true when OTP is sent
    });

    debugPrint("Send OTP Clicked");
  }

  void verifyOtp() {
    if (otpController.text.isEmpty || otpController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid OTP"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Debugging the input values
    debugPrint("Entered Email: ${emailController.text}");
    debugPrint("Entered OTP: ${otpController.text}");

    // Create the OTPVerificationRequestModel instance
    OTPVerificationRequestModel otpVerificationRequest =
        OTPVerificationRequestModel(
      email: emailController.text.trim(),
      otp: otpController.text.trim(),
      token: "", // ✅ Pass the actual stored token
    );

    // Pass the model to handleOTP method to verify OTP
    handleOTP(otpVerificationRequest);

    debugPrint("Verify OTP Clicked");
  }

  // void handleForgotPassword(String email) async {
  //   Dio dio = Dio();
  //   DioClient dioClient =
  //       DioClient(dio); // Assuming DioClient handles the actual HTTP requests
  //   AuthenticationApi authenticationApi =
  //       AuthenticationApi(dioClient: dioClient);
  //   ForgotPasswordRepository repo =
  //       ForgotPasswordRepository(authenticationApi: authenticationApi);

  //   // Call the method to request OTP
  //   // String result = await repo.requestForgotPassword(email);
  //   //   setState(() {
  //   //     storedToken = result['token'];
  //   //   });

  //   // // Show the result as a SnackBar or handle further UI updates
  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   //   SnackBar(
  //   //     content: Text(result), // Show success/failure message from API
  //   //     backgroundColor:
  //   //         result == "OTP sent successfully" ? Colors.green : Colors.red,
  //   //   ),
  //   // );
  //   // Call the method to request OTP
  //   Map<String, dynamic> result =
  //       await repo.requestForgotPassword(email); // ✅ Get full response

  //   setState(() {
  //     storedToken = result['token'] ?? ""; // ✅ Extract token safely
  //   });

  //   // Show the result as a SnackBar
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content:
  //           Text(result['msg'] ?? "Unknown error"), // ✅ Show message from API
  //       backgroundColor: result['token'] != null && result['token'].isNotEmpty
  //           ? Colors.green
  //           : Colors.red,
  //     ),
  //   );
  // }

  void handleForgotPassword(String email) async {
    Dio dio = Dio();
    DioClient dioClient = DioClient(dio);
    AuthenticationApi authenticationApi =
        AuthenticationApi(dioClient: dioClient);
    ForgotPasswordRepository repo =
        ForgotPasswordRepository(authenticationApi: authenticationApi);

    try {
      // Call the method to request OTP
      Map<String, dynamic> result = await repo.requestForgotPassword(email);

      setState(() {
        storedToken = result['token'] ?? ""; // ✅ Extract token safely
      });

      // Show the result as a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP sent to your email"), // ✅ Display success message
          backgroundColor: result['token'] != null && result['token'].isNotEmpty
              ? Colors.green
              : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error sending OTP"),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint("Error: $e");
    }
  }
  // void handleOTP(OTPVerificationRequestModel otpRequest) async {
  //   Dio dio = Dio();
  //   DioClient dioClient =
  //       DioClient(dio); // Assuming DioClient handles the HTTP requests
  //   AuthenticationApi authenticationApi =
  //       AuthenticationApi(dioClient: dioClient);
  //   ForgotPasswordRepository repo =
  //       ForgotPasswordRepository(authenticationApi: authenticationApi);

  //   try {
  //     // Call repo.verifyOTP with email, otp, and token from otpRequest
  //     String result =
  //         await repo.verifyOTP(otpRequest.email, otpRequest.otp, storedToken
  //             // Ensure token is passed
  //             );

  //     // Show the result in SnackBar
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(result),
  //         backgroundColor:
  //             result == "OTP verified successfully" ? Colors.green : Colors.red,
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Error verifying OTP"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     debugPrint("Error: $e");
  //   }
  // }
  // void handleOTP(OTPVerificationRequestModel otpRequest) async {
  //   Dio dio = Dio();
  //   DioClient dioClient =
  //       DioClient(dio); // Assuming DioClient handles the HTTP requests
  //   AuthenticationApi authenticationApi =
  //       AuthenticationApi(dioClient: dioClient);
  //   ForgotPasswordRepository repo =
  //       ForgotPasswordRepository(authenticationApi: authenticationApi);

  //   try {
  //     // Call repo.verifyOTP with email, otp, and token from otpRequest
  //     String result = await repo.verifyOTP(
  //       otpRequest.email,
  //       otpRequest.otp,
  //       storedToken, // Ensure token is passed
  //     );

  //     // Show the result in SnackBar
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(result),
  //         backgroundColor:
  //             result == "OTP verified successfully" ? Colors.green : Colors.red,
  //       ),
  //     );

  //     // If OTP is verified successfully, navigate to login page
  //     if (result.status == true) {
  //       // Navigate to login page
  //       Navigator.pushReplacementNamed(context, SIGN_IN_SCREEN);
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Error verifying OTP"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     debugPrint("Error: $e");
  //   }
  // }
  // void handleOTP(OTPVerificationRequestModel otpRequest) async {
  //   Dio dio = Dio();
  //   DioClient dioClient = DioClient(dio);
  //   AuthenticationApi authenticationApi =
  //       AuthenticationApi(dioClient: dioClient);
  //   ForgotPasswordRepository repo =
  //       ForgotPasswordRepository(authenticationApi: authenticationApi);

  //   try {
  //     Map<String, dynamic> result = await repo.verifyOTP(
  //       otpRequest.email,
  //       otpRequest.otp,
  //       storedToken,
  //     );

  //     // Show message in SnackBar
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(result['msg'] ?? "Unknown error"),
  //         backgroundColor: result['status'] == true ? Colors.green : Colors.red,
  //       ),
  //     );

  //     // If OTP is verified successfully, navigate to login page
  //     if (result['status'] == true) {
  //       Navigator.pushReplacementNamed(context, SIGN_IN_SCREEN);
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Error verifying OTP"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     debugPrint("Error: $e");
  //   }
  // }

  void handleOTP(OTPVerificationRequestModel otpRequest) async {
    Dio dio = Dio();
    DioClient dioClient = DioClient(dio);
    AuthenticationApi authenticationApi =
        AuthenticationApi(dioClient: dioClient);
    ForgotPasswordRepository repo =
        ForgotPasswordRepository(authenticationApi: authenticationApi);

    try {
      Map<String, dynamic> result = await repo.verifyOTP(
        otpRequest.email,
        otpRequest.otp,
        storedToken,
      );

      // Show message in SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Default Password has been sent to your Email. Please login with this password."), // ✅ Display success message
          backgroundColor: result['status'] == true ? Colors.green : Colors.red,
        ),
      );

      // If OTP is verified successfully, navigate to login page
      if (result['status'] == true) {
        Navigator.pushReplacementNamed(context, SIGN_IN_SCREEN);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error verifying OTP"),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(4)),
                  Image.asset(
                    kAppLogo,
                    fit: BoxFit.contain,
                    width: getProportionateScreenWidth(160),
                  ),
                  AppText(
                    text: "Forgot Password!",
                    size: getProportionateScreenWidth(kLargeTextSize),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  if (!isOtpSent) ...[
                    TextField(
                      controller: emailController,
                      style: const TextStyle(
                          color: Colors.black), // Set text color to black
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    ElevatedButton(
                      onPressed: sendOtp, // Call validation function
                      child: const Text("Send OTP"),
                    ),
                  ],
                  if (isOtpSent) ...[
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6, // Restrict OTP to 6 digits
                      style: const TextStyle(
                          color: Colors.black), // Set text color to black
                      decoration: const InputDecoration(
                        labelText: "Enter OTP",
                        prefixIcon: Icon(Icons.lock),
                        counterText: "", // Hide character counter
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    ElevatedButton(
                      onPressed: verifyOtp,
                      child: const Text("Verify OTP"),
                    ),
                  ],
                  SizedBox(height: getProportionateScreenHeight(8)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        debugPrint("Back to Login Clicked");
                        Navigator.pushNamed(context, SIGN_IN_SCREEN);
                      },
                      child: const Text("Back to Login?"),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  const CopyrightText(),
                  SizedBox(
                    height: SizeConfig.isMobileDevice
                        ? getProportionateScreenHeight(20)
                        : getProportionateScreenHeight(18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
