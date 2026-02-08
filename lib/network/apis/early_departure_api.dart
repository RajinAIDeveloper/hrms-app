import 'package:dio/dio.dart';

class EarlyDepartureApi {
  final Dio dioClient;

  EarlyDepartureApi({required this.dioClient});

  Future<Response> saveEarlyDeparture(Map<String, dynamic> request) async {
    try {
      final response = await dioClient.post(
        "/HRMS/Attendance/EarlyDeparture/SaveEarlyDeparture", // Adjust the endpoint as per your backend routing
        data: request,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getEarlyDepartureList(
      Map<String, dynamic> queryParams) async {
    try {
      final response = await dioClient.get(
        "/HRMS/Attendance/EarlyDeparture/GetEarlyDepartureList", // Adjust endpoint as per your backend routing
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
