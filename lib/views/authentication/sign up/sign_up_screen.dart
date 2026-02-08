import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: AppText(text: 'SIGN UP PAGE'),
      ),
    );
  }
}
