import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:root_app/network/dio_client.dart';
import 'package:root_app/constants/token_const.dart';
import 'package:root_app/models/authentication/sign_in_response_model.dart';

class LunchRequestService {
  final DioClient _dioClient;
  
  LunchRequestService(this._dioClient);

  /// Check if the current logged-in user has submitted a lunch request for today
  Future<bool> hasLunchRequestForToday() async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final currentUser = _getCurrentUser();
      
      debugPrint('🔔 Checking lunch request for date: $today');
      debugPrint('🔔 Current user ID: ${currentUser.employeeId}');
      debugPrint('🔔 Current user code: ${currentUser.employeeCode}');

      final response = await _dioClient.get(
        "/hrms/LunchRequest/GetLunchDetails",
        queryParameters: {"date": today},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          final lunchRequests = response.data as List;
          debugPrint('🔔 Total lunch requests found: ${lunchRequests.length}');

          // Check if current user exists in the lunch request list
          final hasRequest = lunchRequests.any((request) {
            final employeeId = request['code']?.toString();
            final employeeCode = currentUser.employeeCode?.toString();
            
            debugPrint('🔔 Comparing: $employeeId == $employeeCode');
            
            // Compare with both employeeId and employeeCode
            return employeeId == employeeCode || 
                   employeeId == currentUser.employeeId.toString();
          });

          debugPrint('🔔 User has lunch request: $hasRequest');
          return hasRequest;
        }
      }

      debugPrint('🔔 No lunch request data or invalid response');
      return false;
    } catch (e) {
      debugPrint('🔔 ❌ Error checking lunch request: $e');
      // Return true on error to avoid false notifications
      return true;
    }
  }

  /// Get current logged-in user from storage
  UserInfo _getCurrentUser() {
    final storage = GetStorage();
    final userJsonString = storage.read(USER_SIGN_IN_KEY);
    
    if (userJsonString == null) {
      throw Exception('User data not found in storage');
    }
    
    try {
      return UserInfo.fromJson(json.decode(userJsonString));
    } catch (e) {
      throw Exception('Failed to parse user data: $e');
    }
  }

  /// Get all lunch requests for a specific date
  Future<List<Map<String, dynamic>>> getLunchRequestsForDate(String date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
      
      final response = await _dioClient.get(
        "/hrms/LunchRequest/GetLunchDetails",
        queryParameters: {"date": formattedDate},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          return List<Map<String, dynamic>>.from(response.data);
        }
      }

      return [];
    } catch (e) {
      debugPrint('❌ Error fetching lunch requests: $e');
      return [];
    }
  }
}