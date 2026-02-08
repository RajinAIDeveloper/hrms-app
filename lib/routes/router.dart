import 'package:flutter/material.dart';
import 'package:root_app/views/Attendance/attendance_screen.dart';
import 'package:root_app/views/Early_departure/early_departure_screen.dart';
import 'package:root_app/views/authentication/forget%20password/forget_password_screen.dart';
import 'package:root_app/views/authentication/sign%20in/sign_in_screen.dart';
import 'package:root_app/views/authentication/sign%20up/sign_up_screen.dart';
import 'package:root_app/views/colleagues/colleagues_screen.dart';
import 'package:root_app/views/error/error_screen.dart';
import 'package:root_app/views/home/home_screen.dart';
import 'package:root_app/views/leave/leave_screen.dart';
import 'package:root_app/views/login_success/login_success_screen.dart';
import 'package:root_app/views/meal/meal_subscription_screen.dart';
import 'package:root_app/views/notification/notification_screen.dart';
import 'package:root_app/views/onboard/onboard_screen.dart';
import 'package:root_app/views/payroll/payroll_screen.dart';
import 'package:root_app/views/profile/profile_screen.dart';
import 'package:root_app/views/Expense/expense_screen.dart';
import 'package:root_app/views/workshift/workshift_screen.dart';
import 'routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  final routeName = settings.name;
  switch (routeName) {
    case ROOT:
    case ONBOARD_SCREEN:
      return MaterialPageRoute(builder: (_) => const OnboardScreen());

    case SIGN_IN_SCREEN:
      return MaterialPageRoute(builder: (_) => const SignInScreen());

    case SIGN_UP_SCREEN:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());

    case FORGOT_PASSWORD_SCREEN:
      return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());

    // case RESET_PASSWORD_SCREEN:
    //   return MaterialPageRoute(
    //       builder: (_) =>
    //           args is String
    //               ? SignInScreen(email: args)
    //               : SignInScreen());

    case HOME_SCREEN:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case LOGIN_SUCCESS_SCREEN:
      return MaterialPageRoute(builder: (_) => const LoginSuccessScreen());
    case PAYROLL_SCREEN:
      return MaterialPageRoute(builder: (_) => const PayrollScreen());
    case LEAVE_SCREEN:
      return MaterialPageRoute(builder: (_) => const LeaveScreen());
    case ATTENDANCE_SCREEN:
      return MaterialPageRoute(builder: (_) => const AttendanceScreen());

    case COLLEAGUES_SCREEN:
      return MaterialPageRoute(builder: (_) => const ColleaguesScreen());
    case NOTIFICATION_SCREEN:
      return MaterialPageRoute(builder: (_) => const NotificationScreen());
    case PROFILE_SCREEN:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    case MEAL_SCREEN:
      return MaterialPageRoute(builder: (_) => const MealSubscriptionScreen());
    case EARLY_DEPARTURE_SCREEN:
      return MaterialPageRoute(builder: (_) => const EarlyDepartureScreen());
    case EXPENSE_SCREEN:
      return MaterialPageRoute(builder: (_) => const ExpenseScreen());
    case SHIFT_SCREEN:
      return MaterialPageRoute(builder: (_) => const WorkshiftScreen());
    case ERROR_SCREEN:
      return MaterialPageRoute(
          builder: (_) => args != null && args is String
              ? ErrorScreen(errorPageName: args)
              : const ErrorScreen(errorPageName: SOMETHING_WENT_WRONG_SCREEN));

    default:
      return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
      builder: (_) => const ErrorScreen(errorPageName: ERROR_404_SCREEN));
}

  /* 
    case SIGN_IN_PAGE:
      return MaterialPageRoute(builder: (_) => SignInPage());

    case FORGOT_PASSWORD_PAGE:
      return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
    // case RESET_PASSWORD_PAGE:
    //   return MaterialPageRoute(builder: (_) => ResetPasswordPage());

    case RESET_PASSWORD_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
              settings.arguments is String && settings.arguments != null
                  ? ResetPasswordPage(email: settings.arguments)
                  : HomePage());

    case HOME_PAGE:
      return MaterialPageRoute(builder: (_) => HomePage());

    case ATTENDANCE_PAGE:
      return MaterialPageRoute(builder: (_) => AttendancePage());

    case LEAVE_PAGE:
      return MaterialPageRoute(
          builder: (_) => LeavePage(
              initialScreen: settings.arguments is LeavePageScreen
                  ? settings.arguments
                  : null));

    case RESIGNATION_PAGE:
      return MaterialPageRoute(
          builder: (_) => ResignationPage(
              initialScreen: settings.arguments is ResignationPageScreen
                  ? settings.arguments
                  : null));

    case RESIGNATION_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is MyResignation
              ? ResignationPageDetail(myResignation: settings.arguments)
              : HomePage());

    case RESIGNATION_PAGE_APPROVAL_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is ResignationAwaiting
              ? ResignationPageApprovalDetail(resignationAwaiting: settings.arguments)
              : HomePage());

    case CREATE_RESIGNATION_PAGE:
      return MaterialPageRoute(builder: (_) => CreateResignationPage());

    case EDIT_RESIGNATION_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is MyResignation
              ? EditResignationPage(myResignation: settings.arguments)
              : HomePage());


    case WORK_FROM_HOME_PAGE:
      return MaterialPageRoute(
          builder: (_) => WorkFromHomePage(
              initialScreen: settings.arguments is WorkFromHomePageScreen
                  ? settings.arguments
                  : null));

    case WORK_FROM_HOME_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is WorkFromHome
              ? WorkFromHomePageDetail(workFromHome: settings.arguments)
              : HomePage());

    case WORK_FROM_HOME_PAGE_APPROVAL_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is WorkFromHomeAwaiting
              ? WorkFromHomePageApprovalDetail(workFromHomeAwaiting: settings.arguments)
              : HomePage());

    case CREATE_WORK_FROM_HOME_PAGE:
      return MaterialPageRoute(builder: (_) => CreateWorkFromHomePage());

    case EDIT_WORK_FROM_HOME_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is MyResignation
              ? EditResignationPage(myResignation: settings.arguments)
              : HomePage());


    case TRAVEL_PLAN_PAGE:
      return MaterialPageRoute(
          builder: (_) => TravelPlanPage(
              initialScreen: settings.arguments is TravelPlanPageScreen
                  ? settings.arguments
                  : null));

    case TRAVEL_PLAN_DETAIL_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is TravelPlan
              ? TravelPlanDetailPage(travelPlan: settings.arguments)
              : HomePage());

    case SETTLEMENT_REQUEST_DETAIL_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is MySettlement
              ? SettlementRequestDetailPage(settlementRequest: settings.arguments)
              :
          settings.arguments != null && settings.arguments is SettlementRequest
          ? SettlementRequestDetailPage(settlementReq: settings.arguments) :
          HomePage());

    case TRAVEL_PLAN_SETTLEMENT_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is TravelSettlement
              ? TravelPlanSettlementPage(settlementPlan: settings.arguments)
              : HomePage());

    case NEW_TRAVEL_PLAN_PAGE:
      return MaterialPageRoute(builder: (_) => NewTravelPlanPage());

    case EDIT_TRAVEL_PLAN_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is TravelPlan
              ? EditTravelPlanPage(travelPlan: settings.arguments)
              : HomePage());

    case EDIT_SETTLEMENT_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is EditSettlement
              ? EditSettlementPage(settlementPlan : settings.arguments)
              : HomePage());

    case MSG_COLLEAGUE_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
              settings.arguments != null && settings.arguments is Colleague
                  ? MsgColleaguesPage(colleague: settings.arguments)
                  : HomePage());

    case COLLEAGUE_Detail_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
              settings.arguments != null && settings.arguments is Colleague
                  ? ColleagueDetailPage(colleague: settings.arguments)
                  : HomePage());

    case EMAIL_COLLEAGUE_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
              settings.arguments != null && settings.arguments is Colleague
                  ? EmailColleaguesPage(colleague: settings.arguments)
                  : HomePage());

    case PROFILE_PAGE:
      return MaterialPageRoute(builder: (_) => ProfilePage());

    case EVENTS_PAGE:
      return MaterialPageRoute(builder: (_) => EventsPage());

    case COLLEAGUES_PAGE:
      return MaterialPageRoute(builder: (_) => ColleaguesPage());

    case PAYROLL_PAGE:
      return MaterialPageRoute(builder: (_) => PayrollPage());

    case NOTIFICATION_PAGE:
      return MaterialPageRoute(builder: (_) => NotificationPage());

    case POLICIES_PAGE:
      return MaterialPageRoute(builder: (_) => PolicesPage());


    case REQUISITION_PAGE:
      return MaterialPageRoute(
          builder: (_) => RequisitionPage());

    case VISITING_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) => VisitingCardPage(
              initialScreen: settings.arguments is VisitingCardPageScreen
                  ? settings.arguments
                  : null));

      case CREATE_VISITING_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateVisitingCardPage());

    case VISITING_CARD_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is VisitingCard
              ? VisitingCardPageDetail(myVisitingCard: settings.arguments) :
          settings.arguments != null && settings.arguments is VisitingCardBHDetails
          ? VisitingCardPageDetail(visitingCardBH: settings.arguments)
              : HomePage());

    case EDIT_VISITING_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is VisitingCard
              ? EditVisitingCardPage(myVisitingCard: settings.arguments)
              : HomePage());



    case ID_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) => IdCardPage(
              initialScreen: settings.arguments is IdCardPageScreen
                  ? settings.arguments
                  : null));

    case CREATE_ID_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateIdCardPage());

    case ID_CARD_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is IdCard
              ? IdCardPageDetail(myIdCard: settings.arguments) :
          settings.arguments != null && settings.arguments is IdCardBHDetails
              ? IdCardPageDetail(idCardBH: settings.arguments)
              : HomePage());

    case EDIT_ID_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is IdCard
              ? EditIdCardPage(myIdCard: settings.arguments)
              : HomePage());


    case LETTER_PAGE:
      return MaterialPageRoute(
          builder: (_) => LetterPage(
              initialScreen: settings.arguments is LetterPageScreen
                  ? settings.arguments
                  : null));

    case CREATE_LETTER_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateLetterPage());

    case LETTER_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Letter
              ? LetterPageDetail(myLetter: settings.arguments)
              : HomePage());

    case EDIT_LETTER_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Letter
              ? EditLetterPage(myLetter: settings.arguments)
              : HomePage());

    case LUNCH_SUBSCRIPTION_PAGE:
      return MaterialPageRoute(
          builder: (_) => LunchSubscriptionPage(
              initialScreen: settings.arguments is LunchSubscriptionPageScreen
                  ? settings.arguments
                  : null));

    case LUNCH_SUBSCRIPTION_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is LunchSubscription
              ? LunchSubscriptionPageDetail(myLunchSubscription: settings.arguments)
              : HomePage());

    case CREATE_LUNCH_SUBSCRIPTION_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateLunchSubscriptionPage());


    case CONVEYANCE_PAGE:
      return MaterialPageRoute(
          builder: (_) => ConveyancePage(
              initialScreen: settings.arguments is ConveyancePageScreen
                  ? settings.arguments
                  : null));

    case CREATE_CONVEYANCE_PAGE:
      return MaterialPageRoute(builder: (_) => CreateConveyancePage());

    case CONVEYANCE_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Conveyance
              ? ConveyancePageDetail(myConveyance: settings.arguments)
              : HomePage());

    case EDIT_CONVEYANCE_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Conveyance
              ? EditConveyancePage(myConveyance: settings.arguments)
              : HomePage());

    case CONVEYANCE_SETTLEMENT_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Conveyance
              ? ConveyanceSettlementPageDetail(myConveyance: settings.arguments)
              : HomePage());

    // case RESIGNATION_PAGE_APPROVAL_DETAIL:
    //   return MaterialPageRoute(
    //       builder: (_) =>
    //       settings.arguments != null && settings.arguments is ResignationAwaiting
    //           ? ResignationPageApprovalDetail(resignationAwaiting: settings.arguments)
    //           : HomePage());
    //

    */


