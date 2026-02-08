import 'package:root_app/models/early_departure/early_departure_item_response.dart';
import 'package:root_app/models/early_departure/early_departure_report_model.dart';
import 'package:root_app/models/early_departure/early_departure_response.dart';

abstract class EarlyDepartureRepository {
  Future<EarlyDepartureResponse> saveEarlyDeparture(
      Map<String, dynamic> request);
  Future<List<EarlyDepartureItem>> getEarlyDepartureList(
      EarlyDepartureReportModel filter);
}
