import "dart:convert";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:get_storage/get_storage.dart";
import "package:root_app/constants/constants.dart";
import "package:root_app/models/authentication/sign_in_response_model.dart";

class DioClient {
  final Dio _dio;
  late String _accessToken;
  static const String _baseUrl = "http://10.0.2.2:5000/api";
 // static const String _baseUrl = "http://103.239.253.11:9088/api";

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = _baseUrl
      ..options.connectTimeout = const Duration(seconds: 115)
      ..options.receiveTimeout = const Duration(seconds: 115)
      ..options.sendTimeout = const Duration(seconds: 115)
      ..options.responseType = ResponseType.json
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers["Access-Control-Allow-Origin"] = "*";
          options.headers["Access-Control-Allow-Credentials"] = true;
          options.headers["Access-Control-Allow-Headers"] =
              "Origin, X-Requested-With, Content-Type, Accept Origin,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale";
          options.headers["Access-Control-Allow-Methods"] = "*";
          options.headers["Access-Control-Allow-Origin"] =
              "POST, OPTIONS, GET, PUT, DELETE, HEAD";
          options.headers["Content-Type"] = "application/json; charset=utf-8";
          options.headers["Accept"] = "application/json";

          debugPrint("=====>>>>>> Request Interceptor Handler <<<<<<======");
          debugPrint(
              "Request Method : ${options.method.toString()} | Request Path : ${options.path.toString()}");
          debugPrint("Request Data : ${options.data.toString()}");

          final token = await _getToken();
          if (token != null) {
            _accessToken = token;
            options.headers["Authorization"] = "Bearer $token";
            options.headers["x_site_info"] = await _getXSitInfo();
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {
          debugPrint("=====>>>>>> Response Interceptor Handler <<<<<<======");
          debugPrint(
              "Response Code : ${response.statusCode.toString()} \nResponse Status Message :  ${response.statusMessage.toString()} \nResponse Data : ${response.data.toString()}");
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          debugPrint("=====>>>>>> Error Interceptor Handler <<<<<<======");
          if (error.response?.statusCode == 401) {
            try {
              // Attempt to refresh token
              if (await _refreshToken()) {
                final token = await _getToken();
                if (token != null) {
                  // Update the failed request with new token
                  error.requestOptions.headers["Authorization"] =
                      "Bearer $token";
                  error.requestOptions.headers["x_site_info"] =
                      await _getXSitInfo();

                  // Retry the failed request with new token
                  final opts = Options(
                      method: error.requestOptions.method,
                      headers: error.requestOptions.headers);

                  final cloneReq = await _dio.request(error.requestOptions.path,
                      options: opts,
                      data: error.requestOptions.data,
                      queryParameters: error.requestOptions.queryParameters);

                  return handler.resolve(cloneReq);
                }
              }
              // If refresh token failed or token is null, let the error propagate
              return handler.next(error);
            } catch (e) {
              debugPrint("Token refresh error: $e");
              // Handle refresh failure - you might want to navigate to login here
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ));
  }

  // Future<String?> _getXSitInfo() async {
  //   final getStorge = GetStorage();
  //   final userJsonString = getStorge.read(USER_SIGN_IN_KEY);
  //   var user = UserInfo.fromJson(json.decode(userJsonString));

  //   var userInfo = {
  //     "u_id": user.userId,
  //     "u_nm": user.username,
  //     "e_id": user.employeeId?.toString(),
  //     "b_id": user.branchId?.toString(),
  //     "dv_id": user.divisionId?.toString(),
  //     "c_id": user.companyId?.toString(),
  //     "o_id": user.organizationId?.toString(),
  //     "dp_id": user.departmentId?.toString(),
  //     "dg_id": user.designationId?.toString(),
  //     "r_id": user.roleId?.toString(),
  //     "r_nm": user.roleName?.toString()
  //   };
  //   return json.encode(userInfo);
  // }

  Future<String?> _getXSitInfo() async {
    final getStorage = GetStorage();
    final userJsonString = getStorage.read(USER_SIGN_IN_KEY);

    if (userJsonString == null || userJsonString is! String) {
      debugPrint('USER_SIGN_IN_KEY is null or not a string');
      return null;
    }

    try {
      final user = UserInfo.fromJson(json.decode(userJsonString));

      final userInfo = {
        "u_id": user.userId,
        "u_nm": user.username,
        "e_id": user.employeeId?.toString(),
        "b_id": user.branchId?.toString(),
        "dv_id": user.divisionId?.toString(),
        "c_id": user.companyId?.toString(),
        "o_id": user.organizationId?.toString(),
        "dp_id": user.departmentId?.toString(),
        "dg_id": user.designationId?.toString(),
        "r_id": user.roleId?.toString(),
        "r_nm": user.roleName?.toString()
      };

      return json.encode(userInfo);
    } catch (e) {
      debugPrint('Failed to decode USER_SIGN_IN_KEY: $e');
      return null;
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken != null) {
      try {
        debugPrint("Refresh Token : $refreshToken");
        final response = await _dio.post("/tokens/refresh", data: {
          "token": _accessToken,
          "refreshToken": refreshToken,
        });

        final newToken = response.data[TOKEN];
        final newRefreshToken = response.data[REFRESH_TOKEN];
        debugPrint("New Token : $newToken");
        debugPrint("New Refresh Token : $newRefreshToken");

        _accessToken = newToken;
        await _setToken(newToken);
        await _setRefreshToken(newRefreshToken);
        return true;
      } on DioException catch (e) {
        debugPrint("Refresh token error: ${e.message}");
        return false;
      }
    }
    return false;
  }

  Future<String?> _getToken() async {
    final getStorge = GetStorage();
    return getStorge.read(TOKEN);
  }

  Future<void> _setToken(String token) async {
    final getStorge = GetStorage();
    return getStorge.write(TOKEN, token);
  }

  Future<String?> _getRefreshToken() async {
    final getStorge = GetStorage();
    return getStorge.read(REFRESH_TOKEN);
  }

  Future<void> _setRefreshToken(String refreshToken) async {
    final getStorge = GetStorage();
    return getStorge.write(REFRESH_TOKEN, refreshToken);
  }

  // HTTP Methods
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters ?? {}, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.post(path, data: data, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.put(path, data: data, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path, Options? options) async {
    try {
      final response = await _dio.delete(path, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> download(String path, String filePath,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.download(path, filePath,
          queryParameters: queryParameters ?? {}, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
