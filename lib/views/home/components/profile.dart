import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/models/profile/profile_model.dart';
import 'package:root_app/views/home/components/components.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.data});

  final ProfileModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(20)),
        ProfilePicture(profile: data),
        ProfileDetails(
          profile: data,
        )
      ],
    );
  }
}
