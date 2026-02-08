import 'package:file_picker/file_picker.dart';
import 'package:root_app/models/expense/account_head_dto.dart';
import 'package:root_app/models/expense/advance_model.dart';
import 'package:root_app/models/expense/conveyance_model.dart';
import 'package:root_app/models/expense/conveyance_response_model.dart';
import 'package:root_app/models/expense/expense_request_model.dart';
import 'package:root_app/models/expense/expense_response_model.dart';
import 'package:root_app/models/expense/requestfilte.dart';
import 'package:root_app/models/expense/travel_model.dart';
import 'package:root_app/models/expense/travel_response_model.dart';

import '../../models/expense/expense_model.dart';

abstract class ExpenseRepository {
  Future<ExpenseResponseModel> getExpenseAmount(int authorityId);
  Future<ExpenseResponseModel> saveAdvance(AdvanceDTO model); // New method
  Future<List<ExpenseRequestModel>> getRequestData(RequestFilter filter);
  Future<TravelResponseModel> saveTravel(TravelDTO model);
   /// Save Conveyance
  Future<ConveyanceResponseModel> saveConveyance(List<ConveyanceDTO> model);
  Future<List<AccountHeadDTO>> getExpensesType(AccountHeadDTO filter);
  Future<ExpenseResponseModel> validateExpenses(List<ExpensesDTO> model);
  Future<ExpenseResponseModel> saveExpenses(List<ExpensesDTO> model, {PlatformFile? file});

}
