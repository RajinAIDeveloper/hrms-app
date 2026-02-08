# HRMS API Documentation

Complete API reference for HRMS Mobile Application with Postman testing instructions.

---

## Table of Contents

1. [Base Configuration](#base-configuration)
2. [Authentication](#authentication)
3. [Attendance](#attendance)
4. [Leave Management](#leave-management)
5. [Early Departure](#early-departure)
6. [Expense Reimbursement](#expense-reimbursement)
7. [Payroll](#payroll)
8. [Profile](#profile)
9. [Colleagues](#colleagues)
10. [Testing Guide](#testing-guide)

---

## Base Configuration

### Base URL
```
Production: http://13.127.139.229:9088/api
Development: http://10.0.2.2:5000/api (Android emulator only)
```

### Global Headers
All authenticated requests require:
```
Content-Type: application/json
Authorization: Bearer {your_jwt_token}
```

### Environment Variables (Postman)
Create these environment variables:
- `base_url`: `http://13.127.139.229:9088/api`
- `token`: (will be set after login)
- `employee_id`: (will be set after login)

---

## 1. AUTHENTICATION

### 1.1 Login (✅ TESTED - WORKING)

**Endpoint:** `POST {{base_url}}/controlpanel/access/LoginByMobile`

**Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "username": "demo@recombd.com",
  "password": "ReCom@2024",
  "remember": true
}
```

**Alternative Credentials:**
```json
{
  "username": "demo_user",
  "password": "Demo@2024",
  "remember": true
}
```

**Expected Response (200 OK):**
```json
{
  "token": "eyJhbGc...",
  "refreshToken": "string (optional)",
  "passObj": {
    "isDefaultPassword": false,
    "defaultCode": "...",
    "isPasswordExpired": true,
    "remainExpireDays": 0
  },
  "privilege": [...]
}
```

**Postman Test Script:**
```javascript
var jsonData = pm.response.json();
pm.environment.set("token", jsonData.token);

// Decode JWT to get employee ID
var base64Url = jsonData.token.split('.')[1];
var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
}).join(''));

var payload = JSON.parse(jsonPayload);
var userInfo = JSON.parse(payload.userinfo);
pm.environment.set("employee_id", userInfo.employeeId);

console.log("Token saved successfully");
console.log("Employee ID:", userInfo.employeeId);
console.log("Employee Name:", userInfo.employeeName);
```

**Status:** ✅ TESTED - WORKING

---

### 1.2 Refresh Token

**Endpoint:** `POST {{base_url}}/tokens/refresh`

**Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "token": "{{token}}",
  "refreshToken": "your_refresh_token"
}
```

**Status:** ⚠️ NOT TESTED (Optional - Refresh token may not be provided by API)

---

### 1.3 Forgot Password

**Endpoint:** `POST {{base_url}}/controlpanel/access/ForgetPassword`

**Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "Email": "user@example.com",
  "PublicIP": "192.168.1.1",
  "PrivateIP": "192.168.1.100",
  "DeviceType": "mobile",
  "OS": "Android",
  "OSVersion": "11",
  "Browser": "Chrome",
  "BrowserVersion": "90"
}
```

**Status:** ❓ NOT TESTED

---

### 1.4 Verify OTP

**Endpoint:** `POST {{base_url}}/controlpanel/access/ForgetPasswordVerification`

**Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "otp": "123456",
  "token": "optional_token_from_forgot_password"
}
```

**Status:** ❓ NOT TESTED

---

## 2. ATTENDANCE

### 2.1 Check Punch In/Out Status

**Endpoint:** `GET {{base_url}}/hrms/dashboard/AttendanceCommonDashboard/CheckPunchInAndPunchOut`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Expected Response:**
```json
{
  "PunchIn": true,
  "PunchOut": false,
  "PunchInAndPunchOut": false,
  "ShiftInTime": "09:00:00",
  "MaxInTime": "09:30:00",
  "ActualInTime": "09:15:00",
  "EarlyInTime": "00:15:00",
  "LateInTime": "00:00:00",
  "ShiftEndTime": "18:00:00",
  "ActualOutTime": null,
  "EarlyGoing": null,
  "OverTime": null,
  "InTimeLocation": "Dhaka",
  "OutTimeLocation": null
}
```

**Testing Steps:**
1. Ensure you've logged in and have `{{token}}` set
2. Send GET request
3. Check response for punch status

**Status:** ❓ TO BE TESTED

---

### 2.2 Get Manual Attendance Records

**Endpoint:** `GET {{base_url}}/HRMS/Attendance/ManualAttendance/GetEmployeeManualAttendances`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Query Parameters:**
```
employeeId={{employee_id}}
pageNumber=1
pageSize=50
```

**Expected Response:**
```json
[
  {
    "manualAttendanceId": 123,
    "employeeId": 20056,
    "employeeName": "Md. Nurul Islam",
    "employeeCode": "83",
    "attendanceDate": "2026-02-05T00:00:00",
    "timeRequestFor": "Both",
    "inTime": "09:30:00",
    "outTime": "18:00:00",
    "reason": "Forgot to punch in/out",
    "stateStatus": "Pending",
    "isApproved": false
  }
]
```

**Status:** ❓ TO BE TESTED

---

### 2.3 Submit Manual Attendance (❌ 404 ERROR - NEED TO FIND CORRECT PATH)

**Endpoint:** `POST {{base_url}}/HRMS/Attendance/ManualAttendance/SaveManualAttendanceApp`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "ManualAttendanceId": 0,
  "ManualAttendanceCode": "",
  "EmployeeId": 20056,
  "DepartmentId": 2,
  "SectionId": 0,
  "UnitId": null,
  "AttendanceDate": "2026-02-05T00:00:00.000Z",
  "TimeRequestFor": "Both",
  "InTime": "09:30:00",
  "OutTime": "18:00:00",
  "StateStatus": "Pending",
  "Reason": "Forgot to punch in/out",
  "Remarks": null
}
```

**Status:** ❌ 404 ERROR - ENDPOINT PATH INCORRECT

**Alternative Paths to Test:**
- `/hrms/attendance/self-manual-attendance` (from menu path)
- `/HRMS/Attendance/ManualAttendance/Save` (shorter path)
- `/hrms/Attendance/SaveManualAttendance` (alternative)

---

## 3. LEAVE MANAGEMENT

### 3.1 Get Yearly Holidays

**Endpoint:** `GET {{base_url}}/HRMS/Attendance/YearlyHoliday/GetYearlyHolidays`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Expected Response:**
```json
{
  "holidays": [
    {
      "yearlyHolidayId": 1,
      "title": "Independence Day",
      "startDate": "2026-03-26T00:00:00",
      "endDate": "2026-03-26T00:00:00",
      "type": "National",
      "remarks": "Bangladesh Independence Day",
      "isDepandentOnMoon": false
    }
  ]
}
```

**Status:** ❓ TO BE TESTED

---

### 3.2 Get Leave Balance

**Endpoint:** `GET {{base_url}}/hrms/dashboard/MyLeaveHistory/GetMyLeaveHistory`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Query Parameters:**
```
ToYear=2026
ToMonth=2
```

**Expected Response:**
```json
{
  "leaveBalance": [
    {
      "LeaveTypeId": 1,
      "LeaveTypeName": "Annual Leave",
      "SerialNo": 1,
      "AllottedLeave": 20,
      "YearlyLeaveTypeAvailed": 5,
      "YearlyLeaveTypeBalance": 15
    }
  ]
}
```

**Status:** ❓ TO BE TESTED

---

### 3.3 Get Leave Applied Records

**Endpoint:** `GET {{base_url}}/hrms/dashboard/LeaveCommonDashboard/GetMyLeaveAppliedRecords`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Expected Response:**
```json
{
  "leaveAppliedRecords": [
    {
      "employeeLeaveRequestId": 1,
      "title": "Annual Leave",
      "appliedTotalDays": 3,
      "appliedFromDate": "2026-02-10T00:00:00",
      "appliedToDate": "2026-02-12T00:00:00",
      "stateStatus": "Approved",
      "approvalRemarks": "Approved by supervisor"
    }
  ]
}
```

**Status:** ❓ TO BE TESTED

---

### 3.4 Submit Leave Request

**Endpoint:** `POST {{base_url}}/hrms/leave/LeaveRequest/SaveEmployeeLeaveRequest3`

**Headers:**
```
Content-Type: multipart/form-data
Authorization: Bearer {{token}}
```

**Request Body (FormData):**
```
EmployeeLeaveRequestId: 0
EmployeeId: {{employee_id}}
LeaveTypeId: 1
LeaveTypeName: Annual Leave
AppliedFromDate: 2026-02-10
AppliedToDate: 2026-02-12
AppliedTotalDays: 3
LeavePurpose: Personal reason
EmergencyPhoneNo: +880123456789
AddressDuringLeave: Dhaka, Bangladesh
Remarks: Emergency leave
LeaveDaysJson: [{"Date":"2026-02-10","Days":1},{"Date":"2026-02-11","Days":1},{"Date":"2026-02-12","Days":1}]
Flag: save
```

**Status:** ❓ TO BE TESTED

---

## 4. EARLY DEPARTURE

### 4.1 Submit Early Departure Request

**Endpoint:** `POST {{base_url}}/HRMS/Attendance/EarlyDeparture/SaveEarlyDeparture`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "EmployeeId": 20056,
  "AppliedDate": "2026-02-05",
  "AppliedTime": "16:00",
  "Reason": "Medical appointment",
  "CancelRemarks": "",
  "StateStatus": "Pending"
}
```

**Status:** ❓ TO BE TESTED

---

### 4.2 Get Early Departure List

**Endpoint:** `GET {{base_url}}/HRMS/Attendance/EarlyDeparture/GetEarlyDepartureList`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Query Parameters:**
```
employeeId={{employee_id}}
pageNumber=1
pageSize=50
```

**Status:** ❓ TO BE TESTED

---

## 5. EXPENSE REIMBURSEMENT

### 5.1 Get Advance Amount

**Endpoint:** `GET {{base_url}}/ExpenseReimbursement/Request/Request/GetAdvanceAmount`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Query Parameters:**
```
authorityId={{employee_id}}
```

**Status:** ❓ TO BE TESTED

---

### 5.2 Submit Advance Request

**Endpoint:** `POST {{base_url}}/ExpenseReimbursement/Request/Request/SaveAdvance`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "employeeId": 20056,
  "requestId": 0,
  "spendMode": "Advance",
  "transactionType": "Advance",
  "transactionDate": "2026-02-05",
  "advanceAmount": 5000,
  "purpose": "Business trip expenses",
  "referenceNumber": "",
  "flag": "save",
  "requestDate": "2026-02-05"
}
```

**Status:** ❓ TO BE TESTED

---

### 5.3 Get Expense Requests

**Endpoint:** `GET {{base_url}}/ExpenseReimbursement/Request/Request/GetRequestData`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Query Parameters:**
```
EmployeeId={{employee_id}}
TransactionType=Expense
Status=Pending
AccountStatus=Pending
SpendMode=Reimbursement
```

**Status:** ❓ TO BE TESTED

---

## 6. PAYROLL

### 6.1 Download Payslip

**Endpoint:** `GET {{base_url}}/payroll/Salary/SalarySelfService/DownloadPayslip`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Query Parameters:**
```
employeeId={{employee_id}}
month=1
year=2026
```

**Response:** PDF file download

**Status:** ❓ TO BE TESTED

---

### 6.2 Download Tax Card

**Endpoint:** `GET {{base_url}}/payroll/Tax/TaxSelfService/DownloadTaxCard`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Query Parameters:**
```
employeeId={{employee_id}}
month=1
year=2026
```

**Response:** PDF file download

**Status:** ❓ TO BE TESTED

---

## 7. PROFILE

### 7.1 Get Employee Profile

**Endpoint:** `GET {{base_url}}/hrms/Employee/Info/GetEmployeeProfileInfo`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Query Parameters:**
```
id={{employee_id}}
```

**Expected Response:**
```json
{
  "employeeId": 20056,
  "employeeCode": "83",
  "employeeName": "Md. Nurul Islam",
  "branchName": "Jr. Software Engineer",
  "gradeName": "",
  "designationName": "Grade B",
  "departmentName": "Baridhara",
  "dateOfJoining": "2020-01-15T00:00:00",
  "dateOfBirth": "1990-05-20T00:00:00",
  "workshift": "General Shift",
  "officeMobile": "+880123456789",
  "officeEmail": "demo@recombd.com",
  "gender": "Male",
  "photoPath": null,
  "isActive": true
}
```

**Status:** ❓ TO BE TESTED

---

## 8. COLLEAGUES

### 8.1 Get Employee Contacts

**Endpoint:** `GET {{base_url}}/hrms/dashboard/CommonDashboard/GetEmployeeContact`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{token}}
```

**Expected Response:**
```json
{
  "colleagues": [
    {
      "id": "20056",
      "text": "Md. Nurul Islam",
      "designationName": "Grade B",
      "officeEmail": "demo@recombd.com",
      "officeMobile": "+880123456789",
      "photoPath": null,
      "bloodGroup": "A+"
    }
  ]
}
```

**Status:** ❓ TO BE TESTED

---

## TESTING GUIDE

### Step-by-Step Testing Instructions

#### 1. Setup Postman Environment

1. Create new environment called "HRMS Production"
2. Add variables:
   - `base_url`: `http://13.127.139.229:9088/api`
   - `token`: (leave empty - will be set by login script)
   - `employee_id`: (leave empty - will be set by login script)

#### 2. Test Authentication (PRIORITY 1)

**2.1 Test Login:**
1. Create new request: POST {{base_url}}/controlpanel/access/LoginByMobile
2. Add request body (see section 1.1)
3. Add test script (see section 1.1)
4. Send request
5. Verify token is saved in environment variables

**Expected Result:** ✅ Token and employee_id saved in environment

---

#### 3. Test Attendance APIs (PRIORITY 2)

**3.1 Test Get Manual Attendance Records:**
1. Create new request: GET {{base_url}}/HRMS/Attendance/ManualAttendance/GetEmployeeManualAttendances
2. Add Authorization header: Bearer {{token}}
3. Add query params: employeeId={{employee_id}}
4. Send request
5. Check response

**If 404 error, try alternative paths:**
- `/hrms/Attendance/ManualAttendance/GetEmployeeManualAttendances`
- `/HRMS/attendance/manual-attendance/records`

**3.2 Test Submit Manual Attendance:**
1. Create new request: POST {{base_url}}/HRMS/Attendance/ManualAttendance/SaveManualAttendanceApp
2. Add Authorization header: Bearer {{token}}
3. Add request body (see section 2.3)
4. Send request
5. Check response

**If 404 error, try alternative paths:**
- `/hrms/attendance/self-manual-attendance`
- `/HRMS/Attendance/ManualAttendance/Save`
- `/hrms/Attendance/SaveManualAttendance`

**Document the working endpoint!**

---

#### 4. Test Leave APIs (PRIORITY 3)

Test in this order:
1. Get Yearly Holidays (3.1)
2. Get Leave Balance (3.2)
3. Get Leave Applied Records (3.3)

**For each endpoint:**
- Add Authorization: Bearer {{token}}
- Send request
- Document response structure
- Note any 404 errors and try alternative paths

---

#### 5. Test Profile API (PRIORITY 4)

1. Test Get Employee Profile (7.1)
2. Verify response contains user data
3. Compare with JWT decoded userinfo

---

#### 6. Test Remaining APIs (PRIORITY 5)

Test in any order:
- Early Departure (4.1, 4.2)
- Expense Reimbursement (5.1, 5.2, 5.3)
- Payroll (6.1, 6.2)
- Colleagues (8.1)

---

### Common Issues & Solutions

#### Issue 1: 404 Not Found
**Cause:** Endpoint path incorrect
**Solution:** Try alternative paths (case sensitivity, module names)

#### Issue 2: 401 Unauthorized
**Cause:** Token missing or expired
**Solution:** Re-login to get fresh token

#### Issue 3: Network Error
**Cause:** Server unreachable
**Solution:** Check base URL, verify server is running

#### Issue 4: 500 Internal Server Error
**Cause:** Server-side error
**Solution:** Check request body structure, required fields

---

### Testing Checklist

- [ ] Login working (saves token)
- [ ] Can decode JWT and extract user info
- [ ] Check Punch In/Out Status working
- [ ] Get Manual Attendance Records working
- [ ] Submit Manual Attendance working (FIND CORRECT PATH!)
- [ ] Get Leave Balance working
- [ ] Get Leave Applied Records working
- [ ] Get Employee Profile working
- [ ] Get Employee Contacts working
- [ ] All endpoints documented with correct paths

---

### Next Steps After Testing

Once you've tested all endpoints:

1. **Document Results:**
   - Mark each endpoint as ✅ WORKING or ❌ FAILED
   - Note correct endpoint paths
   - Document any required header modifications
   - Save example responses

2. **Update API Service Files:**
   - Update `services/attendance.ts` with correct paths
   - Update `services/api.ts` with any header changes
   - Create additional service files as needed

3. **Implement Features:**
   - Start with working endpoints
   - Build UI components
   - Add form validation
   - Handle success/error states

---

## Summary

**Total Endpoints:** 29+

**Categories:**
- ✅ Authentication: 4 endpoints (1 tested, 3 pending)
- ❓ Attendance: 6 endpoints (0 tested)
- ❓ Leave: 7 endpoints (0 tested)
- ❓ Early Departure: 2 endpoints (0 tested)
- ❓ Expense: 8+ endpoints (0 tested)
- ❓ Payroll: 2 endpoints (0 tested)
- ❓ Profile: 1 endpoint (0 tested)
- ❓ Colleagues: 1 endpoint (0 tested)

**Status Legend:**
- ✅ TESTED - WORKING
- ❌ TESTED - FAILED (needs fix)
- ⚠️ NOT TESTED (optional feature)
- ❓ TO BE TESTED (priority testing)

---

**Last Updated:** February 5, 2026
**Author:** HRMS Development Team
**Version:** 1.0
