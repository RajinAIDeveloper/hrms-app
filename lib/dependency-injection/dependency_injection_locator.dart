import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:root_app/network/apis/attendance_api.dart';
import 'package:root_app/network/apis/authentication_api.dart';
import 'package:root_app/network/apis/colleagues_api.dart';
import 'package:root_app/network/apis/early_departure_api.dart';
import 'package:root_app/network/apis/expense_api.dart';
import 'package:root_app/network/apis/leave_api.dart';
import 'package:root_app/network/apis/payroll_api.dart';
import 'package:root_app/network/apis/profile_api.dart';
import 'package:root_app/network/apis/workshift_api.dart';
import 'package:root_app/network/dio_client.dart';
import 'package:root_app/services/attendance/attendance_repository.dart';
import 'package:root_app/services/attendance/attendance_service.dart';
import 'package:root_app/services/authentication/authentication_service.dart';
import 'package:root_app/services/authentication/authentication_repository.dart';
import 'package:root_app/services/colleagues/colleagues_repository.dart';
import 'package:root_app/services/colleagues/colleagues_service.dart';
import 'package:root_app/services/early_departure/early_departure_repository.dart';
import 'package:root_app/services/early_departure/early_departure_service.dart';
import 'package:root_app/services/expense/expense_repository.dart';
import 'package:root_app/services/expense/expense_service.dart';
import 'package:root_app/services/leave/leave_repository.dart';
import 'package:root_app/services/leave/leave_service.dart';
import 'package:root_app/services/meal/lunch_service.dart';
import 'package:root_app/services/notification/notification_service.dart';
import 'package:root_app/services/payroll/payroll_repository.dart';
import 'package:root_app/services/payroll/payroll_service.dart';
import 'package:root_app/services/profile/profile_repository.dart';
import 'package:root_app/services/profile/profile_service.dart';
import 'package:root_app/services/workshift/workshift_repository.dart';
import 'package:root_app/services/workshift/workshift_service.dart';

final getIt = GetIt.instance;

Future<void> dependencyInjections() async {
  //getIt.registerFactory<Service>(() => ServiceImpl()); // New instance
  //getIt.registerSingleton<Service>(ServiceImpl()); // Same instance
  //getIt.registerLazySingleton<Service>(() => ServiceImpl()); // Created when it is first requested

  /// Dio Client

  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<DioClient>(DioClient(getIt<Dio>()));

  /// API

  // getIt.registerSingleton<AuthenticationApi>(AuthenticationApi(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<AuthenticationApi>(
      () => AuthenticationApi(dioClient: getIt<DioClient>()));

  // getIt.registerSingleton<PayrollApi>(PayrollApi(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<PayrollApi>(
      () => PayrollApi(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<AttendanceApi>(
      () => AttendanceApi(dioClient: getIt<DioClient>()));

  getIt.registerLazySingleton<LeaveApi>(
      () => LeaveApi(dioClient: getIt<DioClient>()));

  getIt.registerLazySingleton<ProfileApi>(
      () => ProfileApi(dioClient: getIt<DioClient>()));

  getIt.registerLazySingleton<ColleaguesApi>(
      () => ColleaguesApi(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<EarlyDepartureApi>(
      () => EarlyDepartureApi(dioClient: getIt<Dio>()));
  getIt.registerLazySingleton<WorkshiftApi>(
      () => WorkshiftApi(dioClient: getIt<DioClient>()));
 getIt.registerLazySingleton<ExpenseApi>(
      () => ExpenseApi(dioClient: getIt<DioClient>()));
  /// Services

  // getIt.registerSingleton<AuthenticationRepository>(AuthenticationService(api: getIt.get<AuthenticationApi>()));
  getIt.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationService(api: getIt<AuthenticationApi>()));

  //getIt.registerSingleton<PayrollRepository>(PayrollService(api: getIt.get<PayrollApi>()));
  getIt.registerLazySingleton<PayrollRepository>(
      () => PayrollService(api: getIt<PayrollApi>()));
  getIt.registerLazySingleton<AttendanceRepository>(
      () => AttendanceService(api: getIt<AttendanceApi>()));

  getIt.registerLazySingleton<LeaveRepository>(
      () => LeaveService(api: getIt<LeaveApi>()));

  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileService(api: getIt<ProfileApi>()));

  getIt.registerLazySingleton<ColleaguesRepository>(
      () => ColleaguesService(api: getIt<ColleaguesApi>()));
  getIt.registerLazySingleton<EarlyDepartureRepository>(
      () => EarlyDepartureService(api: getIt<EarlyDepartureApi>()));
  getIt.registerLazySingleton<WorkshiftRepository>(
      () => WorkshiftService(api: getIt<WorkshiftApi>()));

  // Register LunchRequestService
 // Register LunchRequestService
  getIt.registerLazySingleton<LunchRequestService>(
    () => LunchRequestService(getIt<DioClient>())
  );

   // ✅ Register NotificationService
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService()
  );
getIt.registerLazySingleton<ExpenseRepository>(
      () => ExpenseService(api: getIt<ExpenseApi>()));
  //      // ✅ Register Attendance Controller
  // getIt.registerLazySingleton<AttendanceController>(
  //     () => AttendanceController(attendanceService: getIt<AttendanceRepository>()));
}
