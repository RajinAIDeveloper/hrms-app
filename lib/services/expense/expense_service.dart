import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:root_app/models/expense/account_head_dto.dart';
import 'package:root_app/models/expense/advance_model.dart';
import 'package:root_app/models/expense/conveyance_model.dart';
import 'package:root_app/models/expense/conveyance_response_model.dart';
import 'package:root_app/models/expense/expense_model.dart';
import 'package:root_app/models/expense/expense_request_model.dart';
import 'package:root_app/models/expense/expense_response_model.dart';
import 'package:root_app/models/expense/requestfilte.dart';
import 'package:root_app/models/expense/travel_model.dart';
import 'package:root_app/models/expense/travel_response_model.dart';
import 'package:root_app/network/apis/expense_api.dart';
import 'package:root_app/network/dio_exceptions.dart';
import 'package:root_app/services/expense/expense_repository.dart';

class ExpenseService implements ExpenseRepository {
  final ExpenseApi api;

  ExpenseService({required this.api});

  @override
  Future<ExpenseResponseModel> getExpenseAmount(int authorityId) async {
    try {
      final response = await api.getExpenseAmount(authorityId);

      if (response.statusCode == 200 && response.data != null) {
        return ExpenseResponseModel.fromJson(response.data);
      } else {
        return ExpenseResponseModel(
          error: true,
          errorMessage: "No expense data found for this authority ID.",
        );
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exception: $errorMessage <<<<<<==================');
      throw errorMessage;
    } catch (e) {
      debugPrint(
          '====================>>>>>> Unknown Error: $e <<<<<<==================');
      rethrow;
    }
  }

  @override
  // Future<ExpenseResponseModel> saveAdvance(AdvanceDTO model) async {
  //   try {
  //     final response = await api.saveAdvance(model);
  //     if (response.statusCode == 200 && response.data != null) {
  //       return ExpenseResponseModel.fromJson(response.data);
  //     } else {
  //       return ExpenseResponseModel(
  //         error: true,
  //         errorMessage: "Failed to save advance",
  //       );
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
// ============================================
// REPOSITORY METHOD
// ============================================

Future<ExpenseResponseModel> saveAdvance(AdvanceDTO model) async {
  try {
    final response = await api.saveAdvance(model);
    debugPrint('API Response: statusCode=${response.statusCode}, data=${response.data}');

    // Handle successful response with data
    if (response.statusCode == 200 && response.data != null) {
      final parsedResponse = ExpenseResponseModel.fromJson(response.data);
      
      // Check if there's an error in the 200 response
      if (parsedResponse.error) {
        debugPrint('Error detected in 200 response: ${parsedResponse.errorMessage}');
        return parsedResponse;
      }
      
      return parsedResponse;
    }

    // Handle 400/409 validation errors
    else if (response.statusCode == 400 || response.statusCode == 409) {
      final errorMsg = _extractErrorMessage(response.data);
      debugPrint('Validation error (${response.statusCode}): $errorMsg');
      
      return ExpenseResponseModel(
        error: true,
        errorMessage: errorMsg,
      );
    }

    // Handle other error status codes
    else {
      final errorMsg = _extractErrorMessage(response.data);
      debugPrint('Error response (${response.statusCode}): $errorMsg');
      
      return ExpenseResponseModel(
        error: true,
        errorMessage: errorMsg ?? 'Failed to save advance request',
      );
    }
  } on DioException catch (e) {
    debugPrint('DioException in saveAdvance: ${e.message}');
    
    // Extract error from DioException response
    final errorMsg = _extractErrorMessage(e.response?.data);
    
    return ExpenseResponseModel(
      error: true,
      errorMessage: errorMsg ?? e.message ?? 'Network error occurred',
    );
  } catch (e) {
    debugPrint('Unexpected error in saveAdvance: $e');
    return ExpenseResponseModel(
      error: true,
      errorMessage: e.toString(),
    );
  }
}

// Helper method to extract error messages consistently
String? _extractErrorMessage(dynamic data) {
  if (data == null) return null;
  
  if (data is Map<String, dynamic>) {
    // Check all possible error message fields
    if (data['errorMsg'] != null && data['errorMsg'].toString().isNotEmpty) {
      return data['errorMsg'].toString();
    }
    if (data['errorMessage'] != null && data['errorMessage'].toString().isNotEmpty) {
      return data['errorMessage'].toString();
    }
    if (data['msg'] != null && data['msg'].toString().isNotEmpty) {
      return data['msg'].toString();
    }
    if (data['message'] != null && data['message'].toString().isNotEmpty) {
      return data['message'].toString();
    }
    if (data['error'] != null && data['error'] is String && data['error'].toString().isNotEmpty) {
      return data['error'].toString();
    }
  }
  
  return null;
}

  Future<List<ExpenseRequestModel>> getRequestData(RequestFilter filter) async {
    try {
      final response = await api.getRequestData(filter);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((e) => ExpenseRequestModel.fromJson(e)).toList();
      } else {
        throw Exception("No request data found for the given filter.");
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exception: $errorMessage <<<<<<==================');
      throw errorMessage;
    } catch (e) {
      debugPrint(
          '====================>>>>>> Unknown Error: $e <<<<<<==================');
      rethrow;
    }
  }
@override
Future<TravelResponseModel> saveTravel(TravelDTO model) async {
  try {
    final response = await api.saveTravel(model);

    // Handle both 200 with data and 204 No Content
    if (response.statusCode == 200 && response.data != null) {
      return TravelResponseModel.fromJson(response.data);
    } else if (response.statusCode == 204) {
      // No content means success
      return TravelResponseModel(error: false, errorMessage: null);
    } else {
      return TravelResponseModel(
        error: true,
        errorMessage: "Failed to save travel request.",
      );
    }
  } on DioException catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    debugPrint(
        '====================>>>>>> Dio Exception: $errorMessage <<<<<<==================');
    return TravelResponseModel(error: true, errorMessage: errorMessage);
  } catch (e) {
    debugPrint(
        '====================>>>>>> Unknown Error: $e <<<<<<==================');
    return TravelResponseModel(error: true, errorMessage: e.toString());
  }
}
//  Future<ConveyanceResponseModel> saveConveyance(List<ConveyanceDTO> model) async {
//     try {
//       final response = await api.saveConveyance(model);
//       if (response.statusCode == 200 && response.data != null) {
//         return ConveyanceResponseModel.fromJson(response.data);
//       } else {
//         return ConveyanceResponseModel(
//           error: true,
//           errorMessage: "Failed to save conveyance",
//         );
//       }
//     } catch (e) {
//       return ConveyanceResponseModel(
//         error: true,
//         errorMessage: e.toString(),
//       );
//     }
//   }
  Future<ConveyanceResponseModel> saveConveyance(List<ConveyanceDTO> models) async {
  try {
    final response = await api.saveConveyance(models);
    debugPrint('API Response: statusCode=${response.statusCode}, data=${response.data}');

    // Handle successful response with data
    if (response.statusCode == 200 && response.data != null) {
      final parsedResponse = ConveyanceResponseModel.fromJson(response.data);
      
      // Check if there's an error in the 200 response
      if (parsedResponse.error) {
        debugPrint('Error detected in 200 response: ${parsedResponse.errorMessage}');
        return parsedResponse;
      }
      
      return parsedResponse;
    }

    // Handle 400/409 validation errors
    else if (response.statusCode == 400 || response.statusCode == 409) {
      final errorMsg = _extractErrorMessage(response.data);
      debugPrint('Validation error (${response.statusCode}): $errorMsg');
      
      return ConveyanceResponseModel(
        error: true,
        errorMessage: errorMsg ?? 'Validation error occurred',
      );
    }

    // Handle other error status codes
    else {
      final errorMsg = _extractErrorMessage(response.data);
      debugPrint('Error response (${response.statusCode}): $errorMsg');
      
      return ConveyanceResponseModel(
        error: true,
        errorMessage: errorMsg ?? 'Failed to save conveyance request',
      );
    }
  } on DioException catch (e) {
    debugPrint('DioException in saveConveyance: ${e.message}');
    
    // Extract error from DioException response
    final errorMsg = _extractErrorMessage(e.response?.data);
    
    return ConveyanceResponseModel(
      error: true,
      errorMessage: errorMsg ?? e.message ?? 'Network error occurred',
    );
  } catch (e) {
    debugPrint('Unexpected error in saveConveyance: $e');
    return ConveyanceResponseModel(
      error: true,
      errorMessage: e.toString(),
    );
  }
}

@override
  Future<List<AccountHeadDTO>> getExpensesType(AccountHeadDTO filter) async {
    try {
      final response = await api.getExpensesType(filter);
      debugPrint('GetExpensesType API Response: statusCode=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((e) => AccountHeadDTO.fromJson(e)).toList();
      } else {
        throw Exception("No expense types found.");
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exception in getExpensesType: $errorMessage <<<<<<==================');
      throw errorMessage;
    } catch (e) {
      debugPrint(
          '====================>>>>>> Unknown Error in getExpensesType: $e <<<<<<==================');
      rethrow;
    }
  }

  @override
  Future<ExpenseResponseModel> validateExpenses(List<ExpensesDTO> model) async {
    try {
      final response = await api.validateExpenses(model);
      debugPrint('ValidateExpenses API Response: statusCode=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final parsedResponse = ExpenseResponseModel.fromJson(response.data);
        if (parsedResponse.error) {
          debugPrint('Error detected in 200 response: ${parsedResponse.errorMessage}');
          return parsedResponse;
        }
        return parsedResponse;
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        final errorMsg = _extractErrorMessage(response.data);
        debugPrint('Validation error (${response.statusCode}): $errorMsg');
        return ExpenseResponseModel(
          error: true,
          errorMessage: errorMsg ?? 'Validation error occurred',
        );
      } else {
        final errorMsg = _extractErrorMessage(response.data);
        debugPrint('Error response (${response.statusCode}): $errorMsg');
        return ExpenseResponseModel(
          error: true,
          errorMessage: errorMsg ?? 'Failed to validate expenses',
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException in validateExpenses: ${e.message}');
      final errorMsg = _extractErrorMessage(e.response?.data);
      return ExpenseResponseModel(
        error: true,
        errorMessage: errorMsg ?? e.message ?? 'Network error occurred',
      );
    } catch (e) {
      debugPrint('Unexpected error in validateExpenses: $e');
      return ExpenseResponseModel(
        error: true,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<ExpenseResponseModel> saveExpenses(List<ExpensesDTO> model, {PlatformFile? file}) async {
    try {
      Response response;
      if (file != null) {
        final formData = FormData.fromMap({
          'data': jsonEncode(model.map((e) => e.toJson()).toList()),
          'file': await MultipartFile.fromFile(file.path!, filename: file.name),
        });
        response = await api.saveExpensesWithFile(formData);
      } else {
        response = await api.saveExpenses(model);
      }
      debugPrint('SaveExpenses API Response: statusCode=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final parsedResponse = ExpenseResponseModel.fromJson(response.data);
        if (parsedResponse.error) {
          debugPrint('Error detected in 200 response: ${parsedResponse.errorMessage}');
          return parsedResponse;
        }
        return parsedResponse;
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        final errorMsg = _extractErrorMessage(response.data);
        debugPrint('Validation error (${response.statusCode}): $errorMsg');
        return ExpenseResponseModel(
          error: true,
          errorMessage: errorMsg ?? 'Validation error occurred',
        );
      } else {
        final errorMsg = _extractErrorMessage(response.data);
        debugPrint('Error response (${response.statusCode}): $errorMsg');
        return ExpenseResponseModel(
          error: true,
          errorMessage: errorMsg ?? 'Failed to save expenses',
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException in saveExpenses: ${e.message}');
      final errorMsg = _extractErrorMessage(e.response?.data);
      return ExpenseResponseModel(
        error: true,
        errorMessage: errorMsg ?? e.message ?? 'Network error occurred',
      );
    } catch (e) {
      debugPrint('Unexpected error in saveExpenses: $e');
      return ExpenseResponseModel(
        error: true,
        errorMessage: e.toString(),
      );
    }
  }

}
