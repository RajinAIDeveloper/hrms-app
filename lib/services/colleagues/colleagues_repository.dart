import 'package:root_app/models/colleagues/colleagues_response_model.dart';

abstract class ColleaguesRepository {
  Future<ColleaguesResponseModel> colleagues();
}
