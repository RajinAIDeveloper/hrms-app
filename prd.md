Which would be most helpful right now? 🎯Write a PRD (Product Requirement Document) for developers1:46 PMProduct Requirements Document (PRD)
HR Mobile Application
Document Version: 1.0
Last Updated: January 27, 2026
Product Owner: [Your Name]
Target Launch: [Q2 2026]

Table of Contents

Executive Summary
Product Overview
User Personas
Functional Requirements
Technical Requirements
User Interface Specifications
API Requirements
Data Models
Security & Compliance
Performance Requirements
Testing Requirements
Release Plan
Appendices


1. Executive Summary
1.1 Product Vision
A mobile-first HR management system that empowers employees with self-service capabilities for attendance, leave, payroll, and profile management while reducing HR administrative overhead.
1.2 Business Objectives

Reduce HR workload by 60% through employee self-service
Improve attendance accuracy to 98%+ via GPS-based tracking
Increase employee satisfaction by 40% through transparent access to HR data
Achieve 90% daily active users within 3 months of launch

1.3 Success Metrics
MetricTargetMeasurement PeriodDaily Active Users (DAU)90%MonthlyAverage session duration2-3 minutesWeeklyFeature adoption rate80% (core features)QuarterlyUser satisfaction (NPS)50+QuarterlyBug-free sessions99.5%MonthlyAPI response time<500ms (p95)Real-time
1.4 Target Audience

Primary: Full-time employees (500-5000 employees per organization)
Secondary: Managers (approval workflows)
Tertiary: HR administrators (monitoring & support)
Geography: Bangladesh (initial launch), expandable to South Asia


2. Product Overview
2.1 Product Description
A native mobile application (iOS & Android) that provides employees with real-time access to their HR data, enabling them to manage attendance, leaves, payroll, and personal information independently.
2.2 Core Value Propositions
For Employees:

✅ One-tap attendance marking with GPS verification
✅ Apply for leave in under 30 seconds
✅ Instant access to payslips and tax information
✅ Download HR letters without HR intervention
✅ Complete transparency on attendance and leave balances

For Managers:

✅ Quick approval/rejection of requests
✅ Real-time team attendance visibility
✅ Reduced email/paper-based workflows

For HR Department:

✅ 80% reduction in routine queries
✅ Automated record-keeping
✅ Accurate attendance data for payroll
✅ Audit trail for compliance

2.3 Out of Scope (Version 1.0)

❌ Recruitment/hiring workflows
❌ Performance reviews/appraisals
❌ Training management
❌ Employee onboarding workflows (beyond profile setup)
❌ Multi-language support (English only in v1.0)
❌ Biometric attendance integration
❌ Web application (mobile-only)


3. User Personas
Persona 1: Rahim (Regular Employee)
Demographics:

Age: 28
Role: Software Developer
Tech Savviness: High
Location: Dhaka, Bangladesh

Goals:

Mark attendance without forgetting
Apply for leave quickly
Check payslip on payday
Download salary certificate for loan applications

Pain Points:

Forgets to punch in/out
Email-based leave applications take days
Can't access payslips outside office
HR office always busy for certificate requests

App Usage Pattern:

Opens app: 2x daily (morning check-in, evening check-out)
Average session: 1-2 minutes
Peak usage: 8:30-9:30 AM, 5-6 PM


Persona 2: Fatima (Manager)
Demographics:

Age: 35
Role: Team Lead (manages 8 people)
Tech Savviness: Medium
Location: Dhaka, Bangladesh

Goals:

Approve/reject leave requests quickly
Monitor team attendance
Ensure adequate team coverage

Pain Points:

Too many approval emails
Can't see team calendar easily
Late approvals cause employee frustration

App Usage Pattern:

Opens app: 3-4x daily
Average session: 3-5 minutes
Peak usage: Throughout workday


Persona 3: Nazia (HR Administrator)
Demographics:

Age: 32
Role: HR Executive
Tech Savviness: Medium-High
Location: Dhaka, Bangladesh

Goals:

Reduce routine employee queries
Generate accurate reports
Ensure compliance with labor laws

Pain Points:

50+ emails daily with routine requests
Manual attendance corrections
Payroll errors due to attendance data issues

App Usage Pattern:

Uses web dashboard primarily
Opens mobile app: 2-3x daily for urgent approvals
Average session: 5-10 minutes


4. Functional Requirements
4.1 Module 1: Leave Management
4.1.1 Leave Balance Display
Priority: P0 (Must Have)
User Story:

As an employee, I want to see my remaining leave balance at a glance so that I can plan my time off accordingly.

Acceptance Criteria:

 Display leave balance on Home Dashboard
 Show breakdown by leave type (Casual, Sick, Annual, etc.)
 Display carry-forward leaves separately with expiry date
 Update balance in real-time after approval/rejection
 Show visual indicator (progress bar or donut chart)
 Display total available days prominently

Technical Requirements:

API: GET /api/v1/leave/balance
Cache duration: 5 minutes
Offline support: Show last synced data

UI Components:
┌─────────────────────────────────┐
│ Leave Balance                   │
├─────────────────────────────────┤
│ Total Available: 12 days        │
│                                 │
│ Casual Leave    [■■■■■□□□□□] 5/10│
│ Sick Leave      [■■■■■■■□□□] 7/10│
│ Annual Leave    [□□□□□□□□□□] 0/15│
│                                 │
│ Carry Forward: 5 days           │
│ (expires: Mar 31, 2026)         │
└─────────────────────────────────┘
Error Handling:

If balance API fails: Show last cached value with "⚠️ Data may be outdated"
If no data available: Show "0 days available. Contact HR."


4.1.2 Apply Leave
Priority: P0 (Must Have)
User Story:

As an employee, I want to apply for leave in under 30 seconds so that I can quickly submit my request without disrupting my work.

Acceptance Criteria:

 Form loads in <1 second
 Leave type dropdown with available types only
 Date range picker (from-to) with calendar view
 Auto-calculate working days (exclude weekends & holidays)
 Show remaining balance after application
 Optional reason field (max 500 characters)
 Optional attachment (for sick leave: medical certificate)
 Real-time validation:

 Sufficient balance check
 No overlapping dates
 Minimum 1 day notice (configurable)
 No past dates


 Preview summary before submission
 Success confirmation with status tracking

Technical Requirements:

API: POST /api/v1/leave/apply
Max file size: 5MB
Supported formats: JPG, PNG, PDF
Offline support: Save as draft, sync when online

Request Payload:
json{
  "leaveType": "casual|sick|annual|emergency|unpaid",
  "startDate": "2026-02-10",
  "endDate": "2026-02-12",
  "reason": "Family function",
  "attachment": "base64_encoded_string",
  "totalDays": 3,
  "emergencyContact": "+8801711111111"
}
Response:
json{
  "success": true,
  "data": {
    "applicationId": "LEA-2026-00123",
    "status": "pending",
    "approver": "Manager Name",
    "submittedAt": "2026-01-27T10:30:00Z",
    "estimatedApproval": "2026-01-28T18:00:00Z"
  }
}
```

**Validation Rules:**

| Field | Rule | Error Message |
|-------|------|---------------|
| Leave Type | Required | "Please select leave type" |
| Start Date | Required, Future date | "Select a valid future date" |
| End Date | >= Start Date | "End date must be after start date" |
| Balance | Available >= Requested | "Insufficient balance. You have X days left." |
| Overlap | No existing leave | "You already have leave approved for these dates" |
| Attachment | Required for sick leave >3 days | "Medical certificate required" |

**Error Handling:**
- Network failure: Save as draft, show "Saved offline" message
- Validation error: Inline error messages, prevent submission
- Server error: Show "Try again" with retry button

---

#### 4.1.3 Leave History

**Priority:** P0 (Must Have)

**User Story:**
> As an employee, I want to view all my past and upcoming leave applications so that I can track their status and plan accordingly.

**Acceptance Criteria:**
- [ ] Display all applications in reverse chronological order
- [ ] Show status badges: Pending, Approved, Rejected, Cancelled
- [ ] Filter by status, type, and date range
- [ ] Search by date or reason
- [ ] Tap to view full details
- [ ] Option to cancel pending leaves
- [ ] Export history as PDF (last 12 months)

**Technical Requirements:**
- API: `GET /api/v1/leave/history?page=1&limit=20&status=all`
- Pagination: 20 records per page
- Cache: 10 minutes

**UI Components:**
```
┌─────────────────────────────────────┐
│ [All] [Pending] [Approved] [Rejected]│ ← Filter tabs
├─────────────────────────────────────┤
│ Feb 10-12, 2026 (3 days)            │
│ Casual Leave                        │
│ Status: ✅ Approved                  │
│ Reason: Family function             │
│ [View Details]                      │
├─────────────────────────────────────┤
│ Jan 20-21, 2026 (2 days)            │
│ Sick Leave                          │
│ Status: ⏳ Pending                   │
│ [View] [Cancel]                     │
├─────────────────────────────────────┤
│ ... (more records)                  │
└─────────────────────────────────────┘

4.1.4 Leave Calendar View
Priority: P1 (Should Have)
User Story:

As an employee, I want to see a calendar view of my leaves and holidays so that I can visually plan my time off.

Acceptance Criteria:

 Monthly calendar with color-coded dates
 Legend: My leaves, Team leaves (optional), Holidays, Weekends
 Swipe to navigate months
 Tap date to see details
 Option to apply leave from calendar (tap empty date)

Color Coding:

🟢 Green: Approved leave
🟡 Yellow: Pending leave
🔴 Red: Rejected leave
🔵 Blue: Public holiday
⚪ Gray: Weekend

Technical Requirements:

API: GET /api/v1/leave/calendar?month=2026-02
Include public holidays in response
Cache: 1 day


4.1.5 Leave Cancellation
Priority: P1 (Should Have)
User Story:

As an employee, I want to cancel my pending or approved leave if my plans change.

Acceptance Criteria:

 Cancel button visible for pending/approved leaves (at least 1 day before start date)
 Confirmation dialog with reason field
 Notify manager of cancellation
 Restore leave balance after cancellation
 Show cancellation status

Business Rules:

Can cancel pending leaves: Anytime
Can cancel approved leaves: At least 24 hours before start date
Cannot cancel rejected leaves
Cannot cancel leaves that have already started

Technical Requirements:

API: POST /api/v1/leave/{id}/cancel
Payload: { "reason": "Plans changed" }


4.2 Module 2: Attendance Management
4.2.1 GPS-Based Attendance (Punch In/Out)
Priority: P0 (Must Have)
User Story:

As an employee, I want to mark my attendance with one tap using GPS so that I don't need manual attendance sheets.

Acceptance Criteria:

 Big, prominent "PUNCH IN" button on Attendance screen
 GPS location captured automatically
 Verify location within office geofence (configurable radius)
 Show current time, shift timing, GPS status
 Live working hours counter after punch-in
 "PUNCH OUT" button enabled only after minimum shift duration
 Confirmation message with timestamp
 Handle late arrival with reason prompt
 Handle early departure with approval request

Technical Requirements:

GPS accuracy: ±50 meters
Geofence radius: Configurable (default 200m)
Location permission: "While using app"
Background location: NOT required (explicit punch only)
API: POST /api/v1/attendance/punch

Request Payload:
json{
  "type": "in|out",
  "timestamp": "2026-01-27T09:02:34Z",
  "location": {
    "latitude": 23.8103,
    "longitude": 90.4125,
    "accuracy": 12
  },
  "deviceInfo": {
    "model": "Samsung Galaxy S21",
    "os": "Android 13",
    "appVersion": "1.0.0"
  }
}
Response:
json{
  "success": true,
  "data": {
    "attendanceId": "ATT-2026-00456",
    "type": "in",
    "timestamp": "2026-01-27T09:02:34Z",
    "status": "on_time|late|early",
    "lateBy": 0,
    "shiftStart": "09:00:00",
    "shiftEnd": "17:00:00",
    "workingHours": 0,
    "message": "Punched in successfully ✅"
  }
}
```

**UI Flow:**
```
Before Punch In:
┌─────────────────────────────────┐
│                                 │
│     [  PUNCH IN  ]              │
│      (Big Green Button)         │
│                                 │
│ Current Time: 8:58 AM           │
│ Your Shift: 9:00 AM - 5:00 PM   │
│ GPS Status: ✅ Enabled          │
│                                 │
└─────────────────────────────────┘

After Punch In:
┌─────────────────────────────────┐
│ ✅ Punched in at 8:58 AM        │
│                                 │
│ Working Hours: 00:24            │
│ (Live counter)                  │
│                                 │
│ Shift ends at: 5:00 PM          │
│ Remaining: 7h 36m               │
│                                 │
│     [  PUNCH OUT  ]             │
│   (Red, disabled until 5 PM)    │
│                                 │
└─────────────────────────────────┘
Validation Rules:
ConditionActionUser ExperienceGPS disabledPrompt to enable"Enable GPS to continue"Outside geofenceAllow with approval"You're outside office area. Proceed?"Already punched inShow error"You already punched in at [time]"Forgot yesterday's punch outPrompt correction"You didn't punch out yesterday. Request correction?"Network offlineSave locally"Saved. Will sync when online."Late arrival (>15 min)Prompt reason"You're 20 mins late. Please select reason."
Edge Cases:
ScenarioSystem BehaviorImplementationForgot to punch inAllow manual entry with manager approvalShow "Request Manual Entry" buttonForgot to punch outAuto punch-out at shift end + 2 hoursCron job runs at midnightGPS spoofingFlag suspicious locationsBackend validation + distance checksMultiple punch-insReject duplicate"Already checked in today"Weekend punchAllow if shift scheduledCheck shift calendar firstPublic holiday punchWarn but allow (OT tracking)"Today is a holiday. Continue?"

4.2.2 Manual Attendance Entry
Priority: P1 (Should Have)
User Story:

As an employee, I want to submit manual attendance if GPS fails or I forgot to punch in/out, subject to manager approval.

Acceptance Criteria:

 "Manual Attendance" button visible if GPS fails
 Form: Date, In Time, Out Time, Reason
 Requires manager approval
 Shows approval status
 Cannot edit after submission

Technical Requirements:

API: POST /api/v1/attendance/manual
Approval workflow: Manager notified via push notification
Limit: 3 manual entries per month (configurable)

Request Payload:
json{
  "date": "2026-01-26",
  "punchInTime": "09:00:00",
  "punchOutTime": "17:30:00",
  "reason": "GPS not working",
  "evidence": "optional_screenshot_base64"
}
```

---

#### 4.2.3 Attendance History (Monthly Summary)

**Priority:** P0 (Must Have)

**User Story:**
> As an employee, I want to view my monthly attendance summary so that I can verify my records before payroll processing.

**Acceptance Criteria:**
- [ ] Monthly calendar view with color-coded dates
- [ ] Summary cards: Present, Absent, Late, Leave
- [ ] Attendance percentage calculation
- [ ] Toggle between calendar and list view
- [ ] Tap date to see punch-in/out times
- [ ] Filter by status
- [ ] Export as PDF

**Technical Requirements:**
- API: `GET /api/v1/attendance/summary?month=2026-01`
- Cache: 5 minutes
- Generate PDF: Server-side

**UI Components:**
```
┌─────────────────────────────────────┐
│ [< December 2025 >] ← Month selector│
├─────────────────────────────────────┤
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐    │
│ │ 22  │ │  3  │ │  1  │ │  5  │    │
│ │Present│Absent│ Late │Leave │    │
│ └─────┘ └─────┘ └─────┘ └─────┘    │
│                                     │
│ Attendance: 88% (22/25 working days)│
│                                     │
│ [📅 Calendar] [📋 List View]        │
├─────────────────────────────────────┤
│ Calendar View:                      │
│  S  M  T  W  T  F  S                │
│  ✅ ✅ ❌ ✅ ✅ ✅ 🏖               │
│  ✅ ⚠️ ✅ ✅ ❌ ✅ ✅              │
│  ... (rest of month)                │
│                                     │
│ Legend:                             │
│ ✅ Present  ❌ Absent               │
│ ⚠️ Late     🏖 Leave/Holiday        │
└─────────────────────────────────────┘
Color Coding:

✅ Green: Present (on-time)
⚠️ Yellow: Late
❌ Red: Absent
🏖 Blue: Leave or Holiday
⚪ Gray: Weekend


4.2.4 Late Entry Request
Priority: P1 (Should Have)
User Story:

As an employee, I want to submit a reason for arriving late so that my manager can review and approve it.

Acceptance Criteria:

 Automatic prompt when punching in late (>15 mins after shift start)
 Pre-defined reasons: Traffic, Transport delay, Emergency, Other
 Optional text field for details
 Optional attachment (proof)
 Status tracking: Pending, Approved, Rejected
 Manager receives push notification

Technical Requirements:

API: POST /api/v1/attendance/late-request
Auto-trigger: When punchInTime > shiftStart + 15mins
Approval SLA: 24 hours

Request Payload:
json{
  "attendanceId": "ATT-2026-00456",
  "lateBy": 20,
  "reason": "traffic|transport|medical|family|other",
  "details": "Heavy traffic on Mirpur Road",
  "attachment": "optional_base64"
}
```

**Business Rules:**
- Late by 0-15 mins: No action required
- Late by 15-30 mins: Reason required, auto-approved
- Late by 30+ mins: Reason + manager approval required
- 3+ late arrivals in a month: HR notification

---

#### 4.2.5 Attendance Notifications

**Priority:** P1 (Should Have)

**User Story:**
> As an employee, I want to receive reminders and alerts about my attendance so that I don't miss punch-in/out.

**Notification Types:**

| Event | Trigger | Message | Timing |
|-------|---------|---------|--------|
| **Forgot punch-in** | Still not punched in 30 mins after shift | "You haven't punched in yet. Tap to mark attendance." | 9:30 AM |
| **Forgot punch-out** | 30 mins after shift end, no punch-out | "Don't forget to punch out!" | 5:30 PM |
| **Late arrival** | Punched in late | "You were late today. Submit reason?" | Immediately after punch-in |
| **Absent** | No punch-in by end of day | "You were marked absent today. Need correction?" | 11:59 PM |
| **Leave approved** | Manager approves leave | "Your leave for [dates] was approved ✅" | Real-time |
| **Leave rejected** | Manager rejects leave | "Your leave was rejected. Reason: [text]" | Real-time |

**Technical Requirements:**
- Push notification service: Firebase Cloud Messaging (FCM)
- Notification scheduling: Server-side cron jobs
- User preferences: Allow opt-in/opt-out per notification type

---

### 4.3 Module 3: Payroll Management

#### 4.3.1 Payroll Dashboard

**Priority:** P0 (Must Have)

**User Story:**
> As an employee, I want to see a summary of my salary and deductions at a glance so that I understand my compensation.

**Acceptance Criteria:**
- [ ] Display current month's salary (top-most, largest font)
- [ ] Show last month's salary with percentage change
- [ ] Display YTD (Year-to-Date) tax paid
- [ ] Show pending reimbursement claims
- [ ] Quick actions: View Payslip, Tax Center, Reimbursements

**Technical Requirements:**
- API: `GET /api/v1/payroll/dashboard`
- Cache: 1 hour
- Real-time update on 5th of every month

**UI Components:**
```
┌─────────────────────────────────────┐
│ Payroll Dashboard                   │
├─────────────────────────────────────┤
│ This Month (January 2026)           │
│ ৳45,000                             │
│ (Large, prominent display)          │
│                                     │
│ Last Month: ৳43,000 (+4.6% ↗)      │
│ Tax Paid (YTD): ৳12,000             │
│ Pending Claims: ৳2,500              │
├─────────────────────────────────────┤
│ Quick Actions:                      │
│ [💰 View Payslip]                   │
│ [📊 Tax Center]                     │
│ [💸 Reimbursements]                 │
│ [📄 HR Letters]                     │
└─────────────────────────────────────┘
API Response:
json{
  "currentMonth": {
    "month": "2026-01",
    "grossSalary": 50000,
    "deductions": 5000,
    "netSalary": 45000,
    "currency": "BDT"
  },
  "lastMonth": {
    "netSalary": 43000,
    "changePercent": 4.6
  },
  "yearToDate": {
    "totalEarnings": 450000,
    "totalTaxPaid": 12000,
    "totalDeductions": 50000
  },
  "pendingClaims": {
    "count": 2,
    "totalAmount": 2500
  }
}
```

---

#### 4.3.2 Payslip View & Download

**Priority:** P0 (Must Have)

**User Story:**
> As an employee, I want to view and download my monthly payslip so that I can keep records and share with banks for loan applications.

**Acceptance Criteria:**
- [ ] List all payslips (current month highlighted)
- [ ] View payslip in-app (PDF viewer)
- [ ] Download button (saves to device)
- [ ] Share button (email, WhatsApp, Drive)
- [ ] Search by month/year
- [ ] Payslip available by 5th of every month
- [ ] Show breakdown: Earnings, Deductions, Net Pay

**Payslip Components:**
```
┌─────────────────────────────────────┐
│ [Company Logo]                      │
│ SALARY SLIP - January 2026          │
├─────────────────────────────────────┤
│ Employee: Rahim Ahmed               │
│ Employee ID: EMP-001                │
│ Designation: Software Developer     │
│ Department: Engineering             │
│ Bank Account: 1234567890            │
│ Payment Date: February 5, 2026      │
├─────────────────────────────────────┤
│ EARNINGS                Amount (৳)  │
│ Basic Salary             30,000     │
│ House Rent               12,000     │
│ Medical Allowance         2,000     │
│ Conveyance                1,000     │
│ Special Allowance         5,000     │
│ ───────────────────────────────     │
│ GROSS SALARY             50,000     │
├─────────────────────────────────────┤
│ DEDUCTIONS              Amount (৳)  │
│ Tax Deduction             3,000     │
│ Provident Fund            1,500     │
│ Loan Repayment              500     │
│ ───────────────────────────────     │
│ TOTAL DEDUCTIONS          5,000     │
├─────────────────────────────────────┤
│ NET SALARY               45,000     │
│ (In words: Forty-five thousand taka)│
└─────────────────────────────────────┘
```

**Technical Requirements:**
- API: `GET /api/v1/payroll/payslip/{month}`
- PDF generation: Server-side (wkhtmltopdf or similar)
- File size: <500KB per payslip
- Watermark: "Official Payslip - Confidential"
- Password protection: Optional (last 4 digits of employee ID)

**Security:**
- Payslips encrypted at rest
- Download history logged
- Share via secure link (expires in 24 hours)

---

#### 4.3.3 Tax Center

**Priority:** P1 (Should Have)

**User Story:**
> As an employee, I want to track my tax deductions and submit investment declarations so that I can optimize my tax liability.

**Acceptance Criteria:**
- [ ] Display YTD tax paid
- [ ] Show remaining tax liability
- [ ] Investment declaration form
- [ ] AIT (Advance Income Tax) submission
- [ ] Tax return submission
- [ ] Download tax certificate
- [ ] Tax calculation simulator

**Sub-Features:**

##### A. Tax Summary
```
┌─────────────────────────────────────┐
│ Tax Summary (FY 2025-26)            │
├─────────────────────────────────────┤
│ Total Income: ৳600,000              │
│ Tax Paid So Far: ৳12,000            │
│ Estimated Annual Tax: ৳15,000       │
│ Remaining: ৳3,000                   │
│                                     │
│ [View Breakdown] [Simulate]         │
└─────────────────────────────────────┘
B. Investment Declaration

Form fields: PF contribution, Life insurance, DPS, etc.
Upload proof documents (PDF/images)
Submit by deadline (typically Nov 30)
Status tracking: Draft, Submitted, Approved

Technical Requirements:

API: POST /api/v1/tax/declaration
Document upload: Max 5 files, 5MB each
Tax calculation: Based on Bangladesh tax slab (configurable)

C. Tax Certificate Download

Auto-generated based on annual salary
Available after financial year-end (June 30)
Includes all deductions and TDS (Tax Deducted at Source)


4.3.4 Reimbursement Claims
Priority: P1 (Should Have)
User Story:

As an employee, I want to submit reimbursement claims for expenses so that I get reimbursed in my next salary.

Claim Types:

Conveyance
Medical
Travel
Mobile/Internet
Other

Acceptance Criteria:

 Submit claim with category, amount, date
 Upload bills/receipts (mandatory for >৳1000)
 Track claim status: Pending, Approved, Rejected, Paid
 View claim history
 Receive notifications on status change
 See pending claims on Payroll Dashboard

Form Fields:

Claim type (dropdown)
Date of expense (date picker)
Amount (number input)
Description (text area, max 200 chars)
Attachments (multiple uploads, max 5 files)

Technical Requirements:

API: POST /api/v1/payroll/reimbursement
Approval workflow: Manager → Finance
Payment: Included in next salary
Limit: Per claim max ৳10,000 (configurable)

Request Payload:
json{
  "type": "conveyance|medical|travel|mobile|other",
  "date": "2026-01-25",
  "amount": 1500,
  "description": "Client meeting transportation",
  "receipts": [
    "base64_image_1",
    "base64_image_2"
  ]
}
```

---

#### 4.3.5 HR Letters

**Priority:** P0 (Must Have)

**User Story:**
> As an employee, I want to download HR letters instantly without contacting HR so that I can submit them to banks/embassies quickly.

**Letter Types:**

##### A. Salary Certificate (Instant Download)
**Contains:**
- Employee name, designation, employee ID
- Monthly/annual salary
- Date of joining
- Company seal & authorized signature
- Purpose field (auto-filled or editable)

**Acceptance Criteria:**
- [ ] Generate instantly (no approval needed)
- [ ] PDF format, company letterhead
- [ ] Valid for 30 days (expiry mentioned)
- [ ] Download count tracked

##### B. Experience Letter (Requires Approval)
**Contains:**
- Employee name, designation
- Date of joining and leaving
- Work responsibilities summary
- Signature of HR Manager/CEO

**Acceptance Criteria:**
- [ ] Request form: Reason for request
- [ ] Approval by HR/Manager
- [ ] Available for download after approval
- [ ] Notification when ready

##### C. NOC (No Objection Certificate)
**Contains:**
- Statement that company has no objection for employee's specific purpose
- Common uses: Visa, Bank loan, Renting apartment

**Acceptance Criteria:**
- [ ] Request form: Purpose, recipient name
- [ ] Approval by Manager/HR
- [ ] Generated with custom text based on purpose

**Technical Requirements:**
- API: 
  - `GET /api/v1/letters/salary-certificate` (instant)
  - `POST /api/v1/letters/request` (for approval-based)
- PDF template: Company letterhead (configurable)
- Digital signature: Optional (Phase 2)

**UI Flow:**
```
HR Letters Screen
├── Salary Certificate
│   ├── [Download Instantly]
│   └── [Request Custom Format]
├── Experience Letter
│   ├── Status: Not Requested
│   └── [Request Now]
└── NOC
    ├── Status: Pending (requested on Jan 20)
    └── [Track Request]
```

---

### 4.4 Module 4: Shift Management

#### 4.4.1 My Shift Today

**Priority:** P0 (Must Have)

**User Story:**
> As an employee, I want to see my shift timing for today so that I know when to punch in/out.

**Acceptance Criteria:**
- [ ] Display on Home Dashboard
- [ ] Show: Start time, End time, Shift name
- [ ] Highlight if shift is unusual (e.g., night shift)
- [ ] Show countdown to shift start/end

**Technical Requirements:**
- API: `GET /api/v1/shift/today`
- Default shift if none assigned

**UI Component:**
```
┌─────────────────────────────────────┐
│ Today's Shift                       │
├─────────────────────────────────────┤
│ Morning Shift                       │
│ 9:00 AM - 5:00 PM                   │
│                                     │
│ Starts in: 1 hour 23 mins           │
└─────────────────────────────────────┘
```

---

#### 4.4.2 Shift Calendar

**Priority:** P1 (Should Have)

**User Story:**
> As an employee, I want to view my shift schedule for the month so that I can plan my personal commitments.

**Acceptance Criteria:**
- [ ] Monthly calendar view with shift names
- [ ] Color-coded by shift type (morning, evening, night)
- [ ] Tap date to see shift details
- [ ] Toggle to next/previous month
- [ ] Show colleagues' shifts (if permission granted)

**Technical Requirements:**
- API: `GET /api/v1/shift/calendar?month=2026-02`
- Cache: 1 day

**UI Components:**
```
┌─────────────────────────────────────┐
│ [< February 2026 >]                 │
├─────────────────────────────────────┤
│  S   M   T   W   T   F   S          │
│      1   2   3   4   5   6          │
│      🟢  🟢  🟢  🟢  🟢  🔴         │
│  7   8   9  10  11  12  13          │
│  🔴  🟢  🟢  🔵  🔵  🟢  🔴         │
│                                     │
│ Legend:                             │
│ 🟢 Morning (9-5)                    │
│ 🔵 Evening (2-10)                   │
│ 🟠 Night (10-6)                     │
│ 🔴 Off Day                          │
└─────────────────────────────────────┘

4.4.3 Shift Change Request
Priority: P1 (Should Have)
User Story:

As an employee, I want to request a shift change if I have a personal commitment so that I can adjust my work schedule.

Acceptance Criteria:

 Select date for shift change
 Select desired shift
 Provide reason
 Manager approval required
 Notification on approval/rejection

Business Rules:

Request at least 24 hours in advance
Max 4 shift changes per month
Subject to manager approval
Cannot change to a shift with full capacity

Technical Requirements:

API: POST /api/v1/shift/change-request
Approval workflow: Manager → HR (for some shifts)

Request Payload:
json{
  "date": "2026-02-15",
  "currentShift": "morning",
  "requestedShift": "evening",
  "reason": "Personal appointment in morning"
}
```

---

### 4.5 Module 5: Employee Self-Service

#### 4.5.1 Profile View & Edit

**Priority:** P0 (Must Have)

**User Story:**
> As an employee, I want to view and update my personal information so that HR has my correct details.

**Editable Fields:**
- Personal: Phone, Email, Emergency contact
- Address: Current address
- Banking: Bank name, Account number (requires approval)
- Profile photo

**Read-Only Fields (displayed but not editable):**
- Name, Employee ID, Designation
- Date of joining, Department
- Manager name

**Technical Requirements:**
- API: 
  - `GET /api/v1/profile`
  - `PUT /api/v1/profile`
- Photo upload: Max 2MB, JPG/PNG
- Banking changes: Require HR approval

**Validation:**
- Phone: Bangladesh format (+880XXXXXXXXXX)
- Email: Valid format, unique
- Emergency contact: Valid phone number

---

#### 4.5.2 Documents Repository

**Priority:** P1 (Should Have)

**User Story:**
> As an employee, I want to view all my HR documents in one place so that I can reference them when needed.

**Document Types:**
- Offer letter
- Employment contract
- NID/Passport copy
- Educational certificates
- Bank documents
- Previous employment letters

**Acceptance Criteria:**
- [ ] List all documents by category
- [ ] View documents in-app (PDF viewer)
- [ ] Download documents
- [ ] Upload documents (for verification)
- [ ] Document expiry alerts (for passport, work permit, etc.)

**Technical Requirements:**
- API: `GET /api/v1/documents`
- Storage: Encrypted cloud storage (AWS S3 or similar)
- Access control: Employee can only access own documents

---

#### 4.5.3 Company Policies

**Priority:** P1 (Should Have)

**User Story:**
> As an employee, I want to read company policies so that I understand my rights and responsibilities.

**Policy Categories:**
- Leave policy
- Attendance policy
- Code of conduct
- IT policy
- Dress code
- Grievance procedure

**Acceptance Criteria:**
- [ ] Searchable policy list
- [ ] Categorized by topic
- [ ] View as PDF
- [ ] Acknowledgment tracking (employee confirms they read it)
- [ ] Update notifications when policy changes

**Technical Requirements:**
- API: `GET /api/v1/policies`
- Content: PDF files stored on server
- Search: Full-text search on policy titles and summaries

---

#### 4.5.4 Dashboard (Home Screen)

**Priority:** P0 (Must Have)

**User Story:**
> As an employee, I want a personalized dashboard that shows me everything important at a glance.

**Dashboard Components:**
```
┌─────────────────────────────────────┐
│ Good morning, Rahim! 👋             │
│ Monday, January 27, 2026            │
├─────────────────────────────────────┤
│ TODAY'S STATUS                      │
│ ✅ Checked in: 9:02 AM              │
│ Shift: 9:00 AM - 5:00 PM            │
│ Working hours: 2h 15m               │
├─────────────────────────────────────┤
│ QUICK ACTIONS                       │
│ [Apply Leave] [Punch Out]           │
│ [Download Payslip] [View Attendance]│
├─────────────────────────────────────┤
│ STATS                               │
│ Leave Remaining: 12 days            │
│ Attendance: 95% (22/23 days)        │
│ Pending Approvals: 1                │
├─────────────────────────────────────┤
│ NOTIFICATIONS (2 new)               │
│ • Your leave was approved ✅        │
│ • Payslip for Jan available         │
│ [View All]                          │
├─────────────────────────────────────┤
│ UPCOMING                            │
│ • Your leave: Feb 10-12 (3 days)    │
│ • Public holiday: Feb 21            │
└─────────────────────────────────────┘
```

**Personalization:**
- Greeting changes based on time of day
- Quick actions adapt to user's recent behavior
- Notifications prioritized by importance

**Technical Requirements:**
- API: `GET /api/v1/dashboard`
- Cache: 30 seconds (near real-time)
- Offline: Show last cached data

---


### 4.6 Module 6: Lunch Management

#### 4.6.1 Daily Lunch Request

**Priority:** P1 (Should Have)

**User Story:**
> As an employee, I want to request lunch for today or upcoming days so that the office admin can arrange food for me.

**Acceptance Criteria:**
- [ ] "Request Lunch" Quick Action on Home Dashboard.
- [ ] Select date(s) (default: today if < cutoff time).
- [ ] Select meal preference (Standard, Veg, Diet).
- [ ] Cutoff time enforcement (e.g., 10:00 AM for same-day requests).
- [ ] Admin/Manager approval dashboard (bulk approval).
- [ ] Notification on approval/rejection.
- [ ] View lunch status on dashboard (Ordered/Pending/Declined).

**Technical Requirements:**
- API: `POST /api/v1/lunch/request`
- API: `GET /api/v1/lunch/status`
- Cutoff Time: Configurable (system setting).
- Notification: Push notification to Admin when cutoff time approaches with total count.

**UI Components:**
```
┌─────────────────────────────────────┐
│ Request Lunch                       │
│                                     │
│ Select Date:                        │
│ [ Today (Jan 27) ] [ Tomorrow ]     │
│                                     │
│ Preference:                         │
│ (•) Standard (Chicken/Fish)         │
│ ( ) Vegetarian                      │
│ ( ) Diet (Salad/Boiled)             │
│                                     │
│ Note (Optional):                    │
│ [ No spicy food...                ] │
│                                     │
│ [ Submit Request ]                  │
│                                     │
│ ⚠️ Order before 10:00 AM            │
└─────────────────────────────────────┘
```

**Workflow:**
1. Employee requests lunch (Status: Pending).
2. Admin views total count & preferences.
3. Admin approves/confirms order (Status: Approved/Ordered).
4. Employee sees "Lunch Ordered ✅" on dashboard.

---

## 5. Technical Requirements


### 5.1 Platform & Technology Stack

#### Mobile App
- **Platform:** Native (iOS & Android)
- **iOS:** 
  - Language: Swift 5.5+
  - Minimum version: iOS 14.0+
  - Architecture: MVVM + Combine
- **Android:**
  - Language: Kotlin 1.8+
  - Minimum version: Android 8.0 (API 26)+
  - Architecture: MVVM + Coroutines + Flow
- **Alternative:** React Native (if cross-platform preferred)
  - Version: 0.72+
  - State management: Redux Toolkit
  - Navigation: React Navigation 6

#### Backend
- **Framework:** Node.js (Express) OR Laravel (PHP) OR Django (Python)
- **API Style:** RESTful
- **API Version:** v1
- **Base URL:** `https://api.yourcompany.com/v1/`
- **Authentication:** JWT (JSON Web Tokens)
- **Token expiry:** Access token: 1 hour, Refresh token: 30 days

#### Database
- **Primary:** PostgreSQL 14+ (for transactional data)
- **Cache:** Redis 6+ (for sessions, frequently accessed data)
- **File Storage:** AWS S3 or Google Cloud Storage (for documents, photos)

#### DevOps
- **CI/CD:** GitHub Actions or GitLab CI
- **Deployment:** Docker containers on AWS ECS/EKS or Google Cloud Run
- **Monitoring:** New Relic or Datadog
- **Error Tracking:** Sentry
- **Push Notifications:** Firebase Cloud Messaging (FCM)

---

### 5.2 System Architecture
```
┌─────────────────────────────────────────────────────────┐
│                    Mobile Apps                          │
│         (iOS Native / Android Native)                   │
└────────────────────┬────────────────────────────────────┘
                     │ HTTPS/TLS 1.3
                     ↓
┌─────────────────────────────────────────────────────────┐
│                   API Gateway                           │
│         (Load Balancer + Rate Limiting)                 │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────┐
│                Backend API Servers                      │
│         (Node.js/Laravel/Django)                        │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐  │
│  │ Auth Service │  │  HR Service  │  │File Service │  │
│  └──────────────┘  └──────────────┘  └─────────────┘  │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        ↓            ↓            ↓
┌─────────────┐ ┌──────────┐ ┌──────────┐
│ PostgreSQL  │ │  Redis   │ │AWS S3/GCS│
│  (Primary)  │ │ (Cache)  │ │ (Files)  │
└─────────────┘ └──────────┘ └──────────┘
```

---

### 5.3 API Specifications

#### Authentication Endpoints
```
POST /api/v1/auth/login
POST /api/v1/auth/logout
POST /api/v1/auth/refresh-token
POST /api/v1/auth/forgot-password
POST /api/v1/auth/reset-password
POST /api/v1/auth/change-password
```

#### Leave Management Endpoints
```
GET    /api/v1/leave/balance
GET    /api/v1/leave/types
POST   /api/v1/leave/apply
GET    /api/v1/leave/history?page=1&limit=20&status=all
GET    /api/v1/leave/{id}
POST   /api/v1/leave/{id}/cancel
GET    /api/v1/leave/calendar?month=2026-02
GET    /api/v1/leave/holidays?year=2026
```

#### Attendance Endpoints
```
POST   /api/v1/attendance/punch
POST   /api/v1/attendance/manual
GET    /api/v1/attendance/today
GET    /api/v1/attendance/summary?month=2026-01
GET    /api/v1/attendance/history?from=2026-01-01&to=2026-01-31
POST   /api/v1/attendance/late-request
GET    /api/v1/attendance/late-requests
```

#### Payroll Endpoints
```
GET    /api/v1/payroll/dashboard
GET    /api/v1/payroll/payslip/{month}
GET    /api/v1/payroll/payslips?year=2026
POST   /api/v1/payroll/reimbursement
GET    /api/v1/payroll/reimbursements
GET    /api/v1/tax/summary
POST   /api/v1/tax/declaration
GET    /api/v1/tax/certificate
```

#### Shift Management Endpoints
```
GET    /api/v1/shift/today
GET    /api/v1/shift/calendar?month=2026-02
POST   /api/v1/shift/change-request
GET    /api/v1/shift/change-requests
```

#### Profile Endpoints
```
GET    /api/v1/profile
PUT    /api/v1/profile
POST   /api/v1/profile/photo
GET    /api/v1/documents
POST   /api/v1/documents/upload
GET    /api/v1/policies
```

#### HR Letters Endpoints
```
GET    /api/v1/letters/salary-certificate
POST   /api/v1/letters/request
GET    /api/v1/letters/requests
GET    /api/v1/letters/{id}/download
```

#### Notification Endpoints
```
GET    /api/v1/notifications?page=1&limit=20
PUT    /api/v1/notifications/{id}/read
PUT    /api/v1/notifications/read-all
POST   /api/v1/notifications/preferences

5.4 API Response Format (Standard)
Success Response
json{
  "success": true,
  "data": {
    // Response data here
  },
  "message": "Operation successful",
  "timestamp": "2026-01-27T10:30:00Z"
}
Error Response
json{
  "success": false,
  "error": {
    "code": "INSUFFICIENT_LEAVE_BALANCE",
    "message": "You don't have enough leave balance",
    "details": {
      "requested": 5,
      "available": 2
    }
  },
  "timestamp": "2026-01-27T10:30:00Z"
}
Pagination Response
json{
  "success": true,
  "data": {
    "items": [ /* array of items */ ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 100,
      "itemsPerPage": 20,
      "hasNextPage": true,
      "hasPreviousPage": false
    }
  }
}
```

---

### 5.5 Error Codes

| Code | Description | HTTP Status |
|------|-------------|-------------|
| `AUTH_001` | Invalid credentials | 401 |
| `AUTH_002` | Token expired | 401 |
| `AUTH_003` | Unauthorized access | 403 |
| `LEAVE_001` | Insufficient balance | 400 |
| `LEAVE_002` | Overlapping dates | 400 |
| `LEAVE_003` | Invalid date range | 400 |
| `ATT_001` | Already punched in | 400 |
| `ATT_002` | GPS not available | 400 |
| `ATT_003` | Outside geofence | 400 |
| `FILE_001` | File too large | 413 |
| `FILE_002` | Invalid file type | 400 |
| `VAL_001` | Validation error | 422 |
| `SYS_001` | Internal server error | 500 |
| `SYS_002` | Service unavailable | 503 |

---

## 6. User Interface Specifications

### 6.1 Navigation Structure

#### Bottom Navigation Bar (4 Tabs)
```
┌─────────────────────────────────────┐
│                                     │
│         [Screen Content]            │
│                                     │
├─────────────────────────────────────┤
│  🏠      🕒      💰      👤         │
│ Home  Attend  Payroll  Profile      │
└─────────────────────────────────────┘
```

**Tab Definitions:**

| Tab | Icon | Label | Badge | Purpose |
|-----|------|-------|-------|---------|
| Home | House | Home | None | Dashboard, quick actions |
| Attendance | Clock | Attendance | Pending late requests | Punch in/out, history |
| Payroll | Money | Payroll | Pending claims | Salary, tax, reimbursements |
| Profile | Person | Profile | Profile incomplete % | Personal info, settings |

---

### 6.2 Design System

#### Color Palette

**Primary Colors:**
```
Primary:      #2563EB (Blue 600) - Main actions, active states
Primary Dark: #1E40AF (Blue 700) - Pressed states
Primary Light:#3B82F6 (Blue 500) - Hover states
```

**Secondary Colors:**
```
Success: #10B981 (Green 500) - Approved, present
Warning: #F59E0B (Amber 500) - Late, pending
Error:   #EF4444 (Red 500)   - Rejected, absent
Info:    #3B82F6 (Blue 500)  - Information
```

**Neutral Colors:**
```
Black:    #1F2937 (Gray 800) - Primary text
Gray:     #6B7280 (Gray 500) - Secondary text
LightGray:#F3F4F6 (Gray 100) - Background
White:    #FFFFFF             - Cards, surfaces
```

#### Typography

**Font Family:** 
- iOS: SF Pro (system default)
- Android: Roboto (system default)

**Font Sizes:**
```
Heading 1:  28px, Bold, Primary text color
Heading 2:  24px, Bold, Primary text color
Heading 3:  20px, Semibold, Primary text color
Body Large: 16px, Regular, Primary text color
Body:       14px, Regular, Secondary text color
Caption:    12px, Regular, Secondary text color
```

#### Spacing System (8px grid)
```
XS: 4px
S:  8px
M:  16px
L:  24px
XL: 32px
XXL:48px
```

#### Border Radius
```
Small:  4px  (buttons, chips)
Medium: 8px  (cards)
Large:  12px (modals)
Round:  50%  (profile photos, badges)
```

#### Shadows
```
Small:  0 1px 2px rgba(0,0,0,0.05)
Medium: 0 4px 6px rgba(0,0,0,0.1)
Large:  0 10px 15px rgba(0,0,0,0.1)
```

---

### 6.3 Component Library

#### Buttons

**Primary Button:**
```
Background: Primary color
Text: White
Height: 48px
Padding: 16px 24px
Border radius: 8px
Font: 16px, Semibold
States: Default, Hover, Pressed, Disabled
```

**Secondary Button:**
```
Background: White
Border: 1px solid Primary
Text: Primary color
[Other properties same as Primary]
```

**Text Button:**
```
Background: Transparent
Text: Primary color
No border
Padding: 8px 16px
```

#### Cards
```
Background: White
Border radius: 12px
Shadow: Medium
Padding: 16px
Margin bottom: 16px
```

#### Input Fields
```
Height: 48px
Border: 1px solid Gray
Border radius: 8px
Padding: 12px 16px
Font: 16px, Regular
Focus: Border color changes to Primary
Error: Border color Red, helper text below
```

#### Status Chips
```
Approved:  Green background, Green text
Pending:   Amber background, Amber text
Rejected:  Red background, Red text
Present:   Green background, White text
Absent:    Red background, White text
Late:      Amber background, White text

Height: 24px
Padding: 4px 8px
Border radius: 4px
Font: 12px, Semibold
```

---

### 6.4 Screen Layouts (Detailed)

I'll provide detailed wireframes for key screens:

#### Screen 1: Home Dashboard
```
┌─────────────────────────────────────┐
│ ← [Logo]                    🔔 [3]  │ ← Header
├─────────────────────────────────────┤
│ Good morning, Rahim! 👋             │ ← Greeting
│ Monday, January 27, 2026            │ ← Date
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ TODAY'S STATUS                  │ │ ← Status Card
│ │ ✅ Checked in: 9:02 AM          │ │
│ │ Shift: 9:00 AM - 5:00 PM        │ │
│ │ Working: 2h 15m [Live counter]  │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ QUICK ACTIONS                       │ ← Section header
│ ┌──────────┐ ┌──────────┐          │
│ │   📝     │ │   ⏰     │          │ ← Icon grid
│ │  Apply   │ │  Punch   │          │
│ │  Leave   │ │   Out    │          │
│ └──────────┘ └──────────┘          │
│ ┌──────────┐ ┌──────────┐          │
│ │   💰     │ │   📊     │          │
│ │ Payslip  │ │Attendance│          │
│ └──────────┘ └──────────┘          │
├─────────────────────────────────────┤
│ STATS                               │ ← Stats section
│ ┌─────────┐ ┌─────────┐ ┌────────┐ │
│ │   12    │ │   95%   │ │   1    │ │ ← Stat cards
│ │ Leave   │ │Attendance│ │Pending │ │
│ │Remaining│ │ 22/23   │ │Approvals│ │
│ └─────────┘ └─────────┘ └────────┘ │
├─────────────────────────────────────┤
│ NOTIFICATIONS             [View All]│ ← Notifications
│ • Leave approved for Feb 10-12 ✅   │
│ • Payslip available for January 💰 │
├─────────────────────────────────────┤
│ UPCOMING                            │ ← Upcoming section
│ • Your leave: Feb 10-12 (3 days)    │
│ • Public holiday: Feb 21            │
└─────────────────────────────────────┘
│ 🏠     🕒      💰      👤          │ ← Bottom nav
└─────────────────────────────────────┘
```

**Interaction Notes:**
- Pull to refresh updates all data
- Tap notification to see details
- Tap stats card to go to detailed view
- Quick actions are context-aware (show "Punch In" if not checked in)

---

#### Screen 2: Apply Leave Form
```
┌─────────────────────────────────────┐
│ ← Apply Leave              [Close]  │ ← Header with back
├─────────────────────────────────────┤
│                                     │
│ Leave Type *                        │ ← Required field
│ [Casual Leave              ▼]       │ ← Dropdown
│                                     │
│ From Date *                         │
│ [📅 Feb 10, 2026           ▼]       │ ← Date picker
│                                     │
│ To Date *                           │
│ [📅 Feb 12, 2026           ▼]       │ ← Date picker
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Working days: 3                 │ │ ← Auto-calculated
│ │ (Excludes weekends & holidays)  │ │
│ │                                 │ │
│ │ Your balance: 12 days           │ │
│ │ After this leave: 9 days        │ │ ← Balance preview
│ └─────────────────────────────────┘ │
│                                     │
│ Reason (Optional)                   │
│ ┌─────────────────────────────────┐ │
│ │ Family function                 │ │ ← Text area
│ │                                 │ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│ 0/500 characters                    │ ← Character count
│                                     │
│ Attachment (Optional)               │
│ [📎 Attach Document]                │ ← Upload button
│                                     │
│                                     │
├─────────────────────────────────────┤
│          [Submit Leave]             │ ← Primary button
│                                     │
└─────────────────────────────────────┘
```

**Validation Messages (shown inline):**
```
Leave Type: [Empty]
❌ Please select a leave type

Dates: [Past date selected]
❌ Cannot select past dates

Balance: [Insufficient]
❌ Insufficient balance. You have 2 days, requested 5.
```

---

#### Screen 3: Attendance Today
```
┌─────────────────────────────────────┐
│ Attendance                          │ ← Header
├─────────────────────────────────────┤
│                                     │
│          [Current Time]             │ ← Large digital clock
│            11:15 AM                 │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ │      [   PUNCH OUT   ]          │ │ ← Main action
│ │     (Big Red Button)            │ │   (changes based
│ │                                 │ │    on state)
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ✅ Punched in: 9:02 AM          │ │ ← Status card
│ │ 📍 Location verified            │ │
│ │                                 │ │
│ │ Working Hours: 2h 13m           │ │ ← Live counter
│ │ [■■■■■■□□□□] 27% of shift      │ │ ← Progress bar
│ │                                 │ │
│ │ Shift: 9:00 AM - 5:00 PM        │ │
│ │ Remaining: 5h 47m               │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [View Attendance History]           │ ← Secondary action
│                                     │
└─────────────────────────────────────┘
│ 🏠     🕒      💰      👤          │ ← Bottom nav
└─────────────────────────────────────┘
```

**States:**

**Before Punch In:**
```
Button: "PUNCH IN" (Green)
Status: "Ready to check in"
```

**After Punch In:**
```
Button: "PUNCH OUT" (Red, disabled until shift end)
Status: "Checked in at [time]"
Counter: Live working hours
```

**After Punch Out:**
```
Status: "Checked out at [time]"
Summary: "Total hours: 8h 28m"
Button: Removed (or "View Summary")
```

---

#### Screen 4: Payslip List
```
┌─────────────────────────────────────┐
│ ← Payslips                 [Filter] │ ← Header
├─────────────────────────────────────┤
│ [2026 ▼]                   [Search] │ ← Year filter
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ January 2026          [NEW]     │ │ ← Latest (badge)
│ │ Net Salary: ৳45,000             │ │
│ │ Paid on: Feb 5, 2026            │ │
│ │ [View] [Download PDF] [Share]   │ │ ← Action buttons
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ December 2025                   │ │
│ │ Net Salary: ৳43,000             │ │
│ │ Paid on: Jan 5, 2026            │ │
│ │ [View] [Download PDF] [Share]   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ November 2025                   │ │
│ │ Net Salary: ৳43,000             │ │
│ │ Paid on: Dec 5, 2025            │ │
│ │ [View] [Download PDF] [Share]   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [Load More]                         │ ← Pagination
│                                     │
└─────────────────────────────────────┘
Tap "View" → Opens payslip in PDF viewer
Tap "Download" → Saves to device, shows toast "Downloaded ✅"
Tap "Share" → Opens share sheet (WhatsApp, Email, Drive)

6.5 Responsive Design Guidelines
Screen Sizes

Small phones: 320-375px width
Standard phones: 375-414px width
Large phones: 414-428px width
Tablets: 768px+ width (future consideration)

Layout Adjustments

Small phones: Single column, reduce padding to 12px
Standard phones: Single column, standard padding (16px)
Large phones: Can show 2-column grids for quick actions
Tablets: Master-detail view (list + detail side-by-side)


6.6 Accessibility Requirements
WCAG 2.1 Level AA Compliance
Color Contrast:

Text on background: Minimum 4.5:1 ratio
Large text (18px+): Minimum 3:1 ratio
Interactive elements: 3:1 ratio

Touch Targets:

Minimum size: 44x44 points (iOS) / 48x48 dp (Android)
Spacing between targets: Minimum 8px

Text Sizing:

Support dynamic type (iOS) / font scaling (Android)
Test with 200% text size

Screen Reader Support:

All interactive elements labeled
Meaningful descriptions for images
Proper heading hierarchy
Form field labels and hints

Keyboard Navigation:

All actions accessible via keyboard (for future web version)
Clear focus indicators


7. API Requirements (Detailed)
7.1 Authentication Flow
Login API
Endpoint: POST /api/v1/auth/login
Request:
json{
  "employeeId": "EMP-001",
  "password": "SecurePass123!",
  "deviceId": "abc123-device-uuid",
  "deviceType": "android|ios",
  "fcmToken": "firebase_cloud_messaging_token"
}
Response (Success):
json{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "employeeId": "EMP-001",
      "name": "Rahim Ahmed",
      "email": "rahim@company.com",
      "designation": "Software Developer",
      "department": "Engineering",
      "profilePhoto": "https://cdn.company.com/photos/rahim.jpg",
      "isFirstLogin": false
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "refresh_token_here",
      "expiresIn": 3600,
      "tokenType": "Bearer"
    },
    "permissions": {
      "canApproveLeaves": false,
      "canViewTeamAttendance": false,
      "isManager": false,
      "isHR": false
    }
  },
  "message": "Login successful",
  "timestamp": "2026-01-27T10:30:00Z"
}
Response (Error - Invalid Credentials):
json{
  "success": false,
  "error": {
    "code": "AUTH_001",
    "message": "Invalid employee ID or password",
    "field": null
  },
  "timestamp": "2026-01-27T10:30:00Z"
}
Response (Error - Account Locked):
json{
  "success": false,
  "error": {
    "code": "AUTH_004",
    "message": "Account locked due to multiple failed attempts. Try again in 30 minutes.",
    "retryAfter": "2026-01-27T11:00:00Z"
  },
  "timestamp": "2026-01-27T10:30:00Z"
}
Security:

Rate limiting: 5 attempts per 15 minutes per IP
Account lockout: 5 failed attempts = 30-minute lock
Password requirements: Min 8 chars, 1 uppercase, 1 number, 1 special char
HTTPS only
Tokens stored securely (iOS Keychain / Android Keystore)


Refresh Token API
Endpoint: POST /api/v1/auth/refresh-token
Request:
json{
  "refreshToken": "refresh_token_here"
}
Response:
json{
  "success": true,
  "data": {
    "accessToken": "new_access_token",
    "expiresIn": 3600
  }
}
```

---

### 7.2 Leave Management APIs

#### Get Leave Balance

**Endpoint:** `GET /api/v1/leave/balance`

**Headers:**
```
Authorization: Bearer {accessToken}
Response:
json{
  "success": true,
  "data": {
    "totalAvailable": 12,
    "leaveTypes": [
      {
        "type": "casual",
        "name": "Casual Leave",
        "total": 10,
        "used": 5,
        "remaining": 5
      },
      {
        "type": "sick",
        "name": "Sick Leave",
        "total": 10,
        "used": 3,
        "remaining": 7
      },
      {
        "type": "annual",
        "name": "Annual Leave",
        "total": 15,
        "used": 15,
        "remaining": 0
      }
    ],
    "carryForward": {
      "days": 5,
      "expiryDate": "2026-03-31"
    },
    "lastUpdated": "2026-01-27T10:30:00Z"
  }
}
```


### 4.6 Module 6: Lunch Management

#### 4.6.1 Daily Lunch Request

**Priority:** P1 (Should Have)

**User Story:**
> As an employee, I want to request lunch for myself and my guests by a specific cutoff time (e.g., 10:00 AM) so that the office admin can arrange food for us.

**Acceptance Criteria:**
- [ ] "Request Lunch" Quick Action on Home Dashboard.
- [ ] Select date(s) (default: today if < cutoff time).
- [ ] Select meal preference (Standard, Veg, Diet).
- [ ] **Guest Option**: Toggle to add guest meals.
    - [ ] Specify number of guests.
    - [ ] Specify guest meal preferences.
- [ ] **Cutoff Time**: Strict enforcement (e.g., 10:00 AM for same-day requests).
    - [ ] If current time > cutoff, show "Lunch request closed for today".
- [ ] View lunch status on dashboard (Ordered/Pending/Declined).

**Technical Requirements:**
- API: `POST /api/v1/lunch/request`
- API: `GET /api/v1/lunch/status`
- Cutoff Time: 10:00 AM (Configurable).

**UI Components:**
```
┌─────────────────────────────────────┐
│ Request Lunch                       │
│                                     │
│ Select Date:                        │
│ [ Today (Jan 27) ] [ Tomorrow ]     │
│                                     │
│ My Meal:                            │
│ (•) Standard (Chicken/Fish)         │
│ ( ) Vegetarian                      │
│ ( ) Diet (Salad/Boiled)             │
│                                     │
│ [x] Add Guest Meal(s)               │
│     Quantity: [ - ] 2 [ + ]         │
│     Preference: Standard            │
│                                     │
│ Note (Optional):                    │
│ [ No spicy food...                ] │
│                                     │
│ [ Submit Request ]                  │
│                                     │
│ ⚠️ Order before 10:00 AM            │
└─────────────────────────────────────┘
```

**Workflow:**
1. Employee requests lunch (Status: Pending).
2. Admin views total count & preferences methods.
3. Employee sees "Lunch Ordered ✅" status.

---


#### Apply Leave

**Endpoint:** `POST /api/v1/leave/apply`

**Headers:**
```
Authorization: Bearer {accessToken}
Content-Type: application/json
Request:
json{
  "leaveType": "casual",
  "startDate": "2026-02-10",
  "endDate": "2026-02-12",
  "reason": "Family function",
  "attachment": "base64_encoded_image_or_pdf",
  "emergencyContact": "+8801711111111"
}
Response (Success):
json{
  "success": true,
  "data": {
    "applicationId": "LEA-2026-00123",
    "leaveType": "casual",
    "startDate": "2026-02-10",
    "endDate": "2026-02-12",
    "totalDays": 3,
    "workingDays": 3,
    "status": "pending",
    "approver": {
      "name": "Manager Name",
      "designation": "Team Lead"
    },
    "submittedAt": "2026-01-27T10:30:00Z",
    "estimatedApproval": "2026-01-28T18:00:00Z"
  },
  "message": "Leave application submitted successfully"
}
Response (Error - Insufficient Balance):
json{
  "success": false,
  "error": {
    "code": "LEAVE_001",
    "message": "Insufficient leave balance",
    "details": {
      "requested": 5,
      "available": 2,
      "leaveType": "casual"
    }
  }
}
Response (Error - Overlapping Dates):
json{
  "success": false,
  "error": {
    "code": "LEAVE_002",
    "message": "You already have leave approved for these dates",
    "details": {
      "conflictingLeave": {
        "id": "LEA-2026-00115",
        "startDate": "2026-02-11",
        "endDate": "2026-02-13"
      }
    }
  }
}

Get Leave History
Endpoint: GET /api/v1/leave/history
Query Parameters:

page (integer, default: 1)
limit (integer, default: 20, max: 100)
status (string, optional: all|pending|approved|rejected|cancelled)
type (string, optional: casual|sick|annual|emergency)
fromDate (string, optional: YYYY-MM-DD)
toDate (string, optional: YYYY-MM-DD)

Example: GET /api/v1/leave/history?page=1&limit=20&status=approved
Response:
json{
  "success": true,
  "data": {
    "items": [
      {
        "id": "LEA-2026-00123",
        "leaveType": {
          "code": "casual",
          "name": "Casual Leave"
        },
        "startDate": "2026-02-10",
        "endDate": "2026-02-12",
        "totalDays": 3,
        "reason": "Family function",
        "status": "approved",
        "appliedAt": "2026-01-27T10:30:00Z",
        "approvedAt": "2026-01-28T14:20:00Z",
        "approvedBy": {
          "name": "Manager Name",
          "designation": "Team Lead"
        },
        "canCancel": true
      },
      // ... more items
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 3,
      "totalItems": 45,
      "itemsPerPage": 20,
      "hasNextPage": true,
      "hasPreviousPage": false
    }
  }
}

7.3 Attendance APIs
Punch In/Out
Endpoint: POST /api/v1/attendance/punch
Request:
json{
  "type": "in",
  "timestamp": "2026-01-27T09:02:34Z",
  "location": {
    "latitude": 23.8103,
    "longitude": 90.4125,
    "accuracy": 12
  },
  "deviceInfo": {
    "model": "Samsung Galaxy S21",
    "os": "Android 13",
    "appVersion": "1.0.0"
  }
}
Response (Success - On Time):
json{
  "success": true,
  "data": {
    "attendanceId": "ATT-2026-00456",
    "type": "in",
    "timestamp": "2026-01-27T09:02:34Z",
    "status": "on_time",
    "lateBy": 0,
    "shift": {
      "name": "Morning Shift",
      "startTime": "09:00:00",
      "endTime": "17:00:00"
    },
    "location": {
      "latitude": 23.8103,
      "longitude": 90.4125,
      "address": "Gulshan-2, Dhaka"
    },
    "workingHours": 0,
    "message": "Punched in successfully ✅"
  }
}
Response (Warning - Late Arrival):
json{
  "success": true,
  "data": {
    "attendanceId": "ATT-2026-00457",
    "type": "in",
    "timestamp": "2026-01-27T09:22:34Z",
    "status": "late",
    "lateBy": 22,
    "shift": {
      "name": "Morning Shift",
      "startTime": "09:00:00",
      "endTime": "17:00:00"
    },
    "requiresReason": true,
    "message": "You are 22 minutes late. Please provide a reason."
  }
}
Response (Error - Outside Geofence):
json{
  "success": false,
  "error": {
    "code": "ATT_003",
    "message": "You are outside the office area",
    "details": {
      "currentLocation": "2.5 km from office",
      "allowManual": true
    }
  }
}
Response (Error - Already Punched In):
json{
  "success": false,
  "error": {
    "code": "ATT_001",
    "message": "You have already punched in today",
    "details": {
      "existingPunch": {
        "timestamp": "2026-01-27T08:58:00Z",
        "status": "on_time"
      }
    }
  }
}

Get Attendance Summary
Endpoint: GET /api/v1/attendance/summary
Query Parameters:

month (string, required: YYYY-MM)

Example: GET /api/v1/attendance/summary?month=2026-01
Response:
json{
  "success": true,
  "data": {
    "month": "2026-01",
    "summary": {
      "totalWorkingDays": 23,
      "present": 20,
      "absent": 2,
      "late": 1,
      "leave": 0,
      "presentPercentage": 87
    },
    "calendar": [
      {
        "date": "2026-01-01",
        "day": "Wednesday",
        "type": "holiday",
        "reason": "New Year"
      },
      {
        "date": "2026-01-02",
        "day": "Thursday",
        "type": "present",
        "punchIn": "09:00:00",
        "punchOut": "17:30:00",
        "workingHours": 8.5,
        "status": "on_time"
      },
      {
        "date": "2026-01-03",
        "day": "Friday",
        "type": "absent",
        "reason": null
      },
      // ... rest of month
    ],
    "lateRecords": [
      {
        "date": "2026-01-15",
        "lateBy": 20,
        "status": "approved",
        "reason": "Traffic"
      }
    ]
  }
}

7.4 Payroll APIs
Get Payroll Dashboard
Endpoint: GET /api/v1/payroll/dashboard
Response:
json{
  "success": true,
  "data": {
    "currentMonth": {
      "month": "2026-01",
      "monthName": "January 2026",
      "grossSalary": 50000,
      "deductions": 5000,
      "netSalary": 45000,
      "currency": "BDT",
      "paymentDate": "2026-02-05",
      "paymentStatus": "paid"
    },
    "lastMonth": {
      "netSalary": 43000,
      "changeAmount": 2000,
      "changePercent": 4.6
    },
    "yearToDate": {
      "year": 2026,
      "totalEarnings": 450000,
      "totalDeductions": 50000,
      "totalTaxPaid": 12000,
      "netPaid": 388000
    },
    "pendingClaims": {
      "count": 2,
      "totalAmount": 2500,
      "items": [
        {
          "id": "RMB-001",
          "type": "Travel",
          "amount": 1500,
          "status": "pending"
        },
        {
          "id": "RMB-002",
          "type": "Medical",
          "amount": 1000,
          "status": "pending"
        }
      ]
    }
  }
}

Get Payslip
Endpoint: GET /api/v1/payroll/payslip/{month}
Example: GET /api/v1/payroll/payslip/2026-01
Response:
json{
  "success": true,
  "data": {
    "payslipId": "PAY-2026-01-001",
    "month": "2026-01",
    "employee": {
      "id": "EMP-001",
      "name": "Rahim Ahmed",
      "designation": "Software Developer",
      "department": "Engineering",
      "bankAccount": "1234567890",
      "joinDate": "2023-05-01"
    },
    "paymentDate": "2026-02-05",
    "earnings": {
      "basicSalary": 30000,
      "houseRent": 12000,
      "medical": 2000,
      "conveyance": 1000,
      "specialAllowance": 5000,
      "totalEarnings": 50000
    },
    "deductions": {
      "tax": 3000,
      "providentFund": 1500,
      "loanRepayment": 500,
      "totalDeductions": 5000
    },
    "netSalary": 45000,
    "netSalaryInWords": "Forty-five thousand taka only",
    "attendance": {
      "workingDays": 23,
      "present": 22,
      "absent": 1,
      "leave": 0
    },
    "pdfUrl": "https://api.company.com/v1/payroll/payslip/2026-01/download"
  }
}

8. Data Models
8.1 Database Schema
Users Table
sqlCREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    designation VARCHAR(100),
    department VARCHAR(100),
    manager_id UUID REFERENCES users(id),
    join_date DATE NOT NULL,
    profile_photo_url VARCHAR(255),
    phone VARCHAR(20),
    emergency_contact VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active', -- active, inactive, terminated
    is_first_login BOOLEAN DEFAULT true,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_employee_id ON users(employee_id);
CREATE INDEX idx_users_manager_id ON users(manager_id);
Attendance Table
sqlCREATE TABLE attendance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    date DATE NOT NULL,
    punch_in_time TIMESTAMP,
    punch_in_location JSONB, -- {lat, lng, accuracy, address}
    punch_out_time TIMESTAMP,
    punch_out_location JSONB,
    shift_id UUID REFERENCES shifts(id),
    status VARCHAR(20), -- on_time, late, absent, leave, holiday
    late_by_minutes INTEGER DEFAULT 0,
    working_hours DECIMAL(5,2),
    is_manual BOOLEAN DEFAULT false,
    manual_approved_by UUID REFERENCES users(id),
    manual_approval_at TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, date)
);

CREATE INDEX idx_attendance_user_date ON attendance(user_id, date DESC);
CREATE INDEX idx_attendance_status ON attendance(status);
Leave Applications Table
sqlCREATE TABLE leave_applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_number VARCHAR(50) UNIQUE NOT NULL, -- LEA-2026-00123
    user_id UUID NOT NULL REFERENCES users(id),
    leave_type_id UUID NOT NULL REFERENCES leave_types(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_days INTEGER NOT NULL,
    working_days INTEGER NOT NULL,
    reason TEXT,
    attachment_url VARCHAR(255),
    status VARCHAR(20) DEFAULT 'pending', -- pending, approved, rejected, cancelled
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP,
    reviewed_by UUID REFERENCES users(id),
    reviewer_comments TEXT,
    cancelled_at TIMESTAMP,
    cancellation_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_leave_user_id ON leave_applications(user_id);
CREATE INDEX idx_leave_status ON leave_applications(status);
CREATE INDEX idx_leave_dates ON leave_applications(start_date, end_date);
Leave Types Table
sqlCREATE TABLE leave_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) UNIQUE NOT NULL, -- casual, sick, annual
    name VARCHAR(50) NOT NULL,
    annual_quota INTEGER NOT NULL,
    carry_forward_allowed BOOLEAN DEFAULT false,
    max_carry_forward INTEGER DEFAULT 0,
    requires_attachment BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
Leave Balances Table
sqlCREATE TABLE leave_balances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    leave_type_id UUID NOT NULL REFERENCES leave_types(id),
    year INTEGER NOT NULL,
    total_quota INTEGER NOT NULL,
    used INTEGER DEFAULT 0,
    remaining INTEGER,
    carry_forward INTEGER DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, leave_type_id, year)
);

CREATE INDEX idx_leave_balance_user ON leave_balances(user_id, year);
Payroll Table
sqlCREATE TABLE payroll (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    month VARCHAR(7) NOT NULL, -- YYYY-MM
    basic_salary DECIMAL(10,2) NOT NULL,
    house_rent DECIMAL(10,2),
    medical_allowance DECIMAL(10,2),
    conveyance DECIMAL(10,2),
    special_allowance DECIMAL(10,2),
    gross_salary DECIMAL(10,2) NOT NULL,
    tax_deduction DECIMAL(10,2),
    provident_fund DECIMAL(10,2),
    loan_repayment DECIMAL(10,2),
    other_deductions DECIMAL(10,2),
    total_deductions DECIMAL(10,2) NOT NULL,
    net_salary DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    payment_status VARCHAR(20) DEFAULT 'pending', -- pending, paid
    payslip_url VARCHAR(255),
    working_days INTEGER,
    present_days INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payroll_user_month ON payroll(user_id, month DESC);
Reimbursements Table
sqlCREATE TABLE reimbursements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claim_number VARCHAR(50) UNIQUE NOT NULL, -- RMB-2026-001
    user_id UUID NOT NULL REFERENCES users(id),
    type VARCHAR(50) NOT NULL, -- conveyance, medical, travel, etc.
    amount DECIMAL(10,2) NOT NULL,
    expense_date DATE NOT NULL,
    description TEXT,
    receipts JSONB, -- Array of receipt URLs
    status VARCHAR(20) DEFAULT 'pending',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP,
    approved_by UUID REFERENCES users(id),
    rejected_reason TEXT,
    paid_in_month VARCHAR(7), -- YYYY-MM when paid
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reimb_user_status ON reimbursements(user_id, status);
Shifts Table
sqlCREATE TABLE shifts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
User Shifts (Assignment) Table
sqlCREATE TABLE user_shifts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    shift_id UUID NOT NULL REFERENCES shifts(id),
    effective_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, effective_date)
);
Notifications Table
sqlCREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    title VARCHAR(100) NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(50), -- leave_approved, payslip_ready, etc.
    related_id UUID, -- ID of related entity (leave, payroll, etc.)
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notif_user_read ON notifications(user_id, is_read, created_at DESC);

9. Security & Compliance
9.1 Authentication & Authorization
Password Policy

Minimum 8 characters
At least 1 uppercase letter
At least 1 number
At least 1 special character (!@#$%^&*)
Cannot be same as last 3 passwords
Must be changed every 90 days

Session Management

JWT tokens with 1-hour expiry
Refresh tokens with 30-day expiry
Single active session per device (configurable)
Automatic logout after 30 minutes of inactivity

Role-Based Access Control (RBAC)
Roles:

Employee (default)

Own attendance, leave, payroll
Cannot approve requests


Manager

All employee permissions
Approve team's leave requests
View team attendance
Cannot access other teams


HR Administrator

All employee permissions
View all employees' data
Generate reports
Manage leave types, shifts


Admin

Full system access
User management
System configuration




9.2 Data Security
Encryption

In Transit: TLS 1.3 for all API communication
At Rest:

Database: AES-256 encryption
Files: Server-side encryption (AWS S3 SSE or equivalent)
Passwords: bcrypt with salt (cost factor: 12)



Data Privacy

PII Handling:

Phone numbers, addresses masked in logs
Salary data never logged
GPS coordinates rounded to 4 decimal places in logs


Data Retention:

Attendance: 7 years (as per labor law)
Payroll: 7 years
Leave records: 5 years
Logs: 90 days


Right to Access:

Employees can download all their data
API: GET /api/v1/profile/export-data


Right to Deletion:

On employee termination + 7 years
Personal data can be anonymized earlier if not required for legal compliance
