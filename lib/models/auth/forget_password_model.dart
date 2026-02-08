class ForgotPasswordModel {
  String email;
  String? publicIP;
  String? privateIP;
  String? deviceType;
  String? os;
  String? osVersion;
  String? browser;
  String? browserVersion;

  ForgotPasswordModel({
    required this.email,
    this.publicIP,
    this.privateIP,
    this.deviceType,
    this.os,
    this.osVersion,
    this.browser,
    this.browserVersion,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "PublicIP": publicIP,
      "PrivateIP": privateIP,
      "DeviceType": deviceType,
      "OS": os,
      "OSVersion": osVersion,
      "Browser": browser,
      "BrowserVersion": browserVersion,
    };
  }
}

class OTPVerificationRequestModel {
  String email;
  String otp;
  String? token; // Nullable, but ensure it's passed when available

  OTPVerificationRequestModel({
    required this.email,
    required this.otp,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp": otp,
      if (token != null)
        "token": token, // Only include "token" if it's not null
    };
  }
}
