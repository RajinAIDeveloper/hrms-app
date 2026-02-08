import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/components.dart';
import 'package:root_app/provider/user_provider.dart';
import 'package:root_app/routes/routing_constants.dart';

class SignForm extends StatelessWidget {
  SignForm({super.key});

  final _signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Obx((() => AutofillGroup(
        child: Form(
            key: _signInController.signInFormKey,
            autovalidateMode: _signInController.autoValidate.value,
            child: Column(
              children: [
                buildUsernameFormField(),
                SizedBox(height: getProportionateScreenHeight(16)),
                Obx((() => buildPasswordFormField())),
                SizedBox(height: getProportionateScreenHeight(16)),
                Obx((() =>
                    FormError(errors: _signInController.errors.toList()))),
                SizedBox(height: getProportionateScreenHeight(16)),
                Stack(children: [
                  AppDefaultButton(
                    text: !_signInController.isLoading.value ? "Sign In" : "",
                    press: () async {
                      if (_signInController.signInFormKey.currentState!
                          .validate()) {
                        _signInController.signInFormKey.currentState!.save();
                        try {
                          await _signInController.login().then((value) {
                            Provider.of<UserProvider>(context, listen: false)
                                .user = value.userInfo;

                            // Save credentials after successful login
                            TextInput.finishAutofillContext(shouldSave: true);

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LOGIN_SUCCESS_SCREEN,
                              (_) => false,
                            );
                            debugPrint(
                                '====================>>>>>> Login Successful <<<<<<==================');
                          });
                        } catch (e) {
                          _signInController.isLoading.value = false;
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Error',
                              message: 'Message : ${e.toString()}',
                              icon: const Icon(
                                Icons.do_not_touch_outlined,
                                color: Colors.white,
                              ),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red.shade700,
                            ),
                          );
                        }
                      } else {
                        debugPrint(
                            '====================>>>>>> Validation Failed <<<<<<==================');

                        _signInController.autoValidate.value =
                            AutovalidateMode.always;
                      }
                    },
                  ),
                  _signInController.isLoading.value
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(14),
                          ),
                          child: const SpinKitThreeBounce(
                            color: kDotColor,
                            size: 30,
                          ),
                        )
                      : const SizedBox.shrink(),
                ]),
              ],
            )))));
  }

  AppTextField buildClientIdFormField() {
    return AppTextField(
      readOnly: true,
      controller: _signInController.clientIDController,
      keyboardType: TextInputType.text,
      labelText: 'Client ID',
      hintText: 'Enter your Client ID',
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffix: Padding(
        padding: EdgeInsets.only(
          right: getProportionateScreenWidth(8),
        ),
        child: const IconButton(
            onPressed: null, icon: Icon(Icons.card_membership_rounded)),
      ),
      onSaved: (newValue) => _signInController.signInModel.clientID = newValue,
      onChanged: (value) => _signInController.onClientIDChanged(value),
      validator: (value) => _signInController.validateClientID(value!),
    );
  }

  AppTextField buildUsernameFormField() {
    return AppTextField(
      controller: _signInController.usernameController,
      keyboardType: TextInputType.text,
      autofillHints: const [AutofillHints.username],
      labelText: 'Username',
      hintText: 'Enter your Username',
      suffix: Padding(
        padding: EdgeInsets.only(
          right: getProportionateScreenWidth(8),
        ),
        child: const IconButton(onPressed: null, icon: Icon(Icons.person)),
      ),
      onSaved: (newValue) => _signInController.signInModel.username = newValue!,
      onChanged: (value) => _signInController.onUsernameChanged(value),
      validator: (value) => _signInController.validateUsername(value!),
    );
  }

  AppTextField buildEmailFormField() {
    return AppTextField(
      controller: _signInController.emailController,
      keyboardType: TextInputType.emailAddress,
      labelText: 'Email',
      hintText: 'Enter your email',
      suffix: Padding(
        padding: EdgeInsets.only(
          right: getProportionateScreenWidth(8),
        ),
        child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.email_outlined,
              color: kSecondarColor,
            )),
      ),
      onSaved: (newValue) => _signInController.signInModel.email = newValue!,
      onChanged: (value) => _signInController.onEmailChanged(value),
      validator: (value) => _signInController.validateEmail(value!),
    );
  }

  AppTextField buildPasswordFormField() {
    return AppTextField(
      controller: _signInController.passwordController,
      obscureText: _signInController.hidePassword.value,
      autofillHints: [AutofillHints.password],
      labelText: "Password",
      hintText: "Enter your password",
      suffix: Padding(
        padding: EdgeInsets.only(
          right: getProportionateScreenWidth(8),
        ),
        child: IconButton(
          onPressed: () {
            _signInController.hidePassword.value =
                !_signInController.hidePassword.value;
          },
          icon: _signInController.hidePassword.value
              ? const Icon(
                  Icons.visibility_rounded,
                  color: kSecondarColor,
                )
              : const Icon(Icons.visibility_off),
        ),
      ),
      onSaved: (newValue) => _signInController.signInModel.password = newValue!,
      onChanged: (value) => _signInController.onPasswordChanged(value),
      validator: (value) => _signInController.validatePassword(value!),
    );
  }
}
