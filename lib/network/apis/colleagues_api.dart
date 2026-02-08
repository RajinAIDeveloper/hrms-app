import 'package:dio/dio.dart';
import 'package:root_app/network/dio_client.dart';

class ColleaguesApi {
  final DioClient dioClient;
  ColleaguesApi({required this.dioClient});

  Future<Response> getColleagues() async {
    try {
      final response = await dioClient.get(
        "/hrms/dashboard/CommonDashboard/GetEmployeeContact",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
