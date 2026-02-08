import 'package:root_app/models/early_departure/early_departure_item_response.dart';
import 'package:root_app/models/early_departure/early_departure_report_model.dart';
import 'package:root_app/models/early_departure/early_departure_response.dart';
import 'package:root_app/network/apis/early_departure_api.dart';
import 'package:root_app/services/early_departure/early_departure_repository.dart';

class EarlyDepartureService implements EarlyDepartureRepository {
  final EarlyDepartureApi api;

  EarlyDepartureService({required this.api});

  @override
  Future<EarlyDepartureResponse> saveEarlyDeparture(
      Map<String, dynamic> request) async {
    try {
      // Add only the date part for AppliedDate
      //request['appliedDate'] = DateTime.now().toIso8601String();

      final response = await api.saveEarlyDeparture(request);
      return EarlyDepartureResponse.fromJson(response.data);
    } catch (e) {
      return EarlyDepartureResponse(
        status: false,
        message: e.toString(),
      );
    }
  }

  Future<List<EarlyDepartureItem>> getEarlyDepartureList(
      EarlyDepartureReportModel filter) async {
    try {
      final response = await api.getEarlyDepartureList(filter.toQueryParams());
      final jsonData = response.data as List<dynamic>;
      return jsonData.map((item) => EarlyDepartureItem.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch early departure list: $e');
    }
  }
}
