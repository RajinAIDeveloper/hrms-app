export interface GetAdvanceAmountParams {
  authorityId: number;
}

export type SpendMode = 'Advance' | 'Reimbursement';
export type TransactionType = 'Advance' | 'Expense';

export interface SaveAdvanceRequest {
  employeeId: number;
  requestId: number;
  spendMode: SpendMode;
  transactionType: TransactionType;
  transactionDate: string; // YYYY-MM-DD
  advanceAmount: number;
  purpose: string;
  referenceNumber?: string;
  flag: 'save' | 'update';
  requestDate: string; // YYYY-MM-DD
}

export interface SaveAdvanceResponse {
  status?: boolean;
  message?: string;
}

export interface GetRequestDataParams {
  EmployeeId: number;
  TransactionType: TransactionType;
  Status?: string;
  AccountStatus?: string;
  SpendMode: SpendMode;
}

export interface ExpenseRequestRecord {
  requestId?: number;
  employeeId?: number;
  transactionType?: string;
  spendMode?: string;
  transactionDate?: string;
  requestDate?: string;
  advanceAmount?: number;
  purpose?: string;
  status?: string;
  accountStatus?: string;
  referenceNumber?: string;
  [key: string]: any;
}

