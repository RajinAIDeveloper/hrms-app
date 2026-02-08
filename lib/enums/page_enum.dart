// ignore_for_file: constant_identifier_names

enum PayrollScreen {
  Main,
  PaySlip,
  TaxCard,
}

enum LeaveScreen {
  Main,
  Holidays,
  SelfLeave,
  ViewLeave,
  LeaveReport,
  LeaveRequests
}

enum ColleaguesScreen {
  Main,
  Colleagues,
}

enum AttendanceScreen {
  Main,
  ManualAttendance, // A screen for general attendance functionality
  GeoLocation, // Screen for geolocation check-in/check-out functionality
  AttendanceReport, // A detailed attendance report screen
  Timeline, // A screen showing a timeline of check-in/check-out history
}

enum EarlyDepartureScreen {
  Main,
  EarlyDeparture,
  EarlyDepartureReport,
}

enum ExpenseScreen {
  Main,
  ExpenseRequestScreen,
  ExpenseForm,
  ExpenseReport,
  ExpenseRequest,
  ExpenseApproval,
}

enum WorkShiftScreen {
  Main,
  WorkShift,
  WorkShiftReport,
  WorkShiftMain,
  WorkShiftList,
  WorkshiftCalender,
}
