import 'package:dio/dio.dart';
import 'package:root_app/models/expense/account_head_dto.dart';
import 'package:root_app/models/expense/advance_model.dart';
import 'package:root_app/models/expense/conveyance_model.dart';
import 'package:root_app/models/expense/expense_model.dart';
import 'package:root_app/models/expense/requestfilte.dart';
import 'package:root_app/models/expense/travel_model.dart';
import 'package:root_app/network/dio_client.dart';

class ExpenseApi {
  final DioClient dioClient;
  ExpenseApi({required this.dioClient});

  /// Get Expense Amount by authority ID
  Future<Response> getExpenseAmount(int authorityId) async {
    try {
      final response = await dioClient.get(
        "/ExpenseReimbursement/Request/Request/GetAdvanceAmount",
        queryParameters: {"authorityId": authorityId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveAdvance(AdvanceDTO model) async {
    return dioClient.post(
      "/ExpenseReimbursement/Request/Request/SaveAdvance",
      data: model.toJson(),
    );
  }

  Future<Response> getRequestData(RequestFilter filter) async {
    try {
      final response = await dioClient.get(
        "/ExpenseReimbursement/Request/Request/GetRequestData",
        queryParameters: {
          "EmployeeId": filter.employeeId,
          "TransactionType": filter.transactionType,
          "Status": filter.status,
          "AccountStatus": filter.accountStatus,
          "SpendMode": filter.spendMode,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveTravel(TravelDTO model) async {
    return dioClient.post(
      "/ExpenseReimbursement/Request/Request/SaveTravel",
      data: model.toJson(),
    );
  }

 Future<Response> saveConveyance(List<ConveyanceDTO> model) async {
  return dioClient.post(
    "/ExpenseReimbursement/Request/Request/SaveConveyance",
    data: model.map((e) => e.toJson()).toList(), // e is now clearly ConveyanceDTO
  );
}
Future<Response> getExpensesType(AccountHeadDTO filter) async {
    return dioClient.get(
      "/ExpenseReimbursement/Request/GetExpensesType",
      queryParameters: filter.toJson(),
    );
  }

  Future<Response> validateExpenses(List<ExpensesDTO> model) async {
    return dioClient.post(
      "/ExpenseReimbursement/Request/Request/ValidationExpenses",
      data: model.map((e) => e.toJson()).toList(),
    );
  }

  Future<Response> saveExpenses(List<ExpensesDTO> model) async {
    return dioClient.post(
      "/ExpenseReimbursement/Request/Request/SaveExpenses",
      data: model.map((e) => e.toJson()).toList(),
    );
  }

  Future<Response> saveExpensesWithFile(FormData formData) async {
    return dioClient.post(
      "/ExpenseReimbursement/Request/Request/SaveExpenses",
      data: formData,
    );
  }
}
