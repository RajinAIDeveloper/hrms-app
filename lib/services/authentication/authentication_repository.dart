// ignore: file_names
import 'package:root_app/models/authentication/components.dart';

abstract class AuthenticationRepository {
  Future<SignInResponseModel> signIn(SignInModel model);
  //Future<Response> ForgetPasswordText(ForgotPasswordModel model);
}
