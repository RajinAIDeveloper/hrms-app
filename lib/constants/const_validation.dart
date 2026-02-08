// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
//newly added
final RegExp phoneValidatorRegExp = RegExp(r"^\+?[1-9]\d{1,14}$");
final RegExp textValidatorRegExp = RegExp(r"^[a-zA-Z\s]+$");
final RegExp numberValidatorRegExp = RegExp(r"^\d+(\.\d+)?$");
//previous added
const String kClientIDNullError = "Please enter your Client ID";
const String kInvalidClientIDError = "Please enter valid Client ID";
const String kEmailNullError = "Please enter your email";
const String kUsernameNullError = "Please enter your Username";
const String kInvalidEmailError = "Please enter valid email";
const String kInvalidUsernameError = "Please enter valid Username";
const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please enter your name";
const String kPhoneNumberNullError = "Please enter your phone number";
const String kAddressNullError = "Please enter your address";

const String kMonthNotSelectedError = "Please Select Month";
const String kYearNotSelectedError = "Please Select Year";
const String kStatusNotSelectedError = "Please Select Status";

const String kLeaveTypeNotSelectedError = "Please Select Leave Type";
const String kLeaveDurationNotSelectedError = "Please Select Leave Duration";
const String kLeaveDurationTypeNotSelectedError =
    "Please Select Half-Day Duration Type";
const String kLeavePurposeNullError = "Please enter your purpose";
const String kInvalidLeavePurposeError = "Please enter valid purpose";

const String kEmergencyPhoneNullError = "Please enter your Emergency Phone";
const String kInvalidEmergencyPhoneError = "Please enter valid Emergency Phone";

const String kAddressDuringLeaveNullError =
    "Please enter your Address During Leavee";
const String kInvalidAddressDuringLeaveError =
    "Please enter valid Address During Leave";

// Expense Form Errors
const String kTransactionTypeNotSelectedError =
    "Please Select Transaction Type";
const String kSpendModeNotSelectedError = "Please Select Spend Mode";
const String kTransactionDateNullError = "Please Select Transaction Date";
const String kPurposeNullError = "Please Enter Purpose";
const String kInvalidPurposeError = "Please Enter Valid Purpose";
const String kCompanyNameNullError = "Please Enter Company Name";
const String kInvalidCompanyNameError = "Please Enter Valid Company Name";
const String kAdvanceAmountNullError = "Please Enter Advance Amount";
const String kInvalidAdvanceAmountError = "Please Enter Valid Advance Amount";
const String kDestinationNullError = "Please Enter Destination City";
const String kInvalidDestinationError = "Please Enter Valid Destination City";
const String kTransportationNullError = "Please Select Transportation";
const String kTransportationCostsNullError =
    "Please Enter Transportation Costs";
const String kInvalidTransportationCostsError =
    "Please Enter Valid Transportation Costs";
const String kAccommodationCostsNullError = "Please Enter Accommodation Costs";
const String kInvalidAccommodationCostsError =
    "Please Enter Valid Accommodation Costs";
const String kSubsistenceCostsNullError = "Please Enter Subsistence Costs";
const String kInvalidSubsistenceCostsError =
    "Please Enter Valid Subsistence Costs";
const String kOtherCostsInvalidError = "Please Enter Valid Other Costs";
const String kItemNullError = "Please Enter Item";
const String kInvalidItemError = "Please Enter Valid Item";
const String kQuantityNullError = "Please Enter Quantity";
const String kInvalidQuantityError = "Please Enter Valid Quantity";
const String kPriceNullError = "Please Enter Price";
const String kInvalidPriceError = "Please Enter Valid Price";
const String kParticularNullError = "Please Enter Particulars";
const String kInvalidParticularError = "Please Enter Valid Particulars";
const String kBillTypeNullError = "Please Enter Bill Type";
const String kInvalidBillTypeError = "Please Enter Valid Bill Type";
const String kCostNullError = "Please Enter Cost";
const String kInvalidCostError = "Please Enter Valid Cost";
const String kInstitutionNullError = "Please Enter Institution Name";
const String kInvalidInstitutionError = "Please Enter Valid Institution Name";
const String kCourseNullError = "Please Enter Course Name";
const String kInvalidCourseError = "Please Enter Valid Course Name";
const String kDurationNullError = "Please Enter Duration";
const String kInvalidDurationError = "Please Enter Valid Duration";
const String kCostsNullError = "Please Enter Costs";
const String kInvalidCostsError = "Please Enter Valid Costs";

//

class ValidationCheck {
  static bool isValidEmail(String value) {
    if (emailValidatorRegExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static bool isValidMinLength(String value, int min) {
    if (value.length >= min) {
      return true;
    }
    return false;
  }

  static bool isValidMaxLength(String value, int max) {
    if (value.length <= max) {
      return true;
    }
    return false;
  }

  //newly added
  static bool isValidPhone(String value) {
    return phoneValidatorRegExp.hasMatch(value);
  }

  static bool isValidText(String value) {
    return textValidatorRegExp.hasMatch(value);
  }

  static bool isValidNumber(String value) {
    return numberValidatorRegExp.hasMatch(value);
  }

  static bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }

  static bool isValidDate(DateTime? date) {
    return date != null;
  }
}
