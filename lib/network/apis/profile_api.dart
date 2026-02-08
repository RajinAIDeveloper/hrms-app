import 'package:dio/dio.dart';
import 'package:root_app/network/dio_client.dart';

class ProfileApi {
  final DioClient dioClient;
  ProfileApi({required this.dioClient});

  Future<Response> getProfile(int id) async {
    try {
      String queryParam = "?id=$id";
      final response = await dioClient
          .get("/hrms/Employee/Info/GetEmployeeProfileInfo$queryParam");
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
