import 'package:root_app/models/profile/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> userProfile(int id);
}
