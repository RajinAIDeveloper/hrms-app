import apiClient from './api';
import {
  ExpenseRequestRecord,
  GetAdvanceAmountParams,
  GetRequestDataParams,
  SaveAdvanceRequest,
  SaveAdvanceResponse,
} from '../types/expense.types';

const parseAdvanceAmount = (data: any): number => {
  if (typeof data === 'number') return data;
  if (typeof data?.advanceAmount === 'number') return data.advanceAmount;
  if (typeof data?.amount === 'number') return data.amount;
  if (typeof data?.data === 'number') return data.data;
  return 0;
};

export const expenseApi = {
  getAdvanceAmount: async (params: GetAdvanceAmountParams) => {
    const res = await apiClient.get<any>('/ExpenseReimbursement/Request/Request/GetAdvanceAmount', { params });
    return parseAdvanceAmount(res.data);
  },

  saveAdvance: (payload: SaveAdvanceRequest) =>
    apiClient.post<SaveAdvanceResponse>('/ExpenseReimbursement/Request/Request/SaveAdvance', payload),

  getRequests: async (params: GetRequestDataParams) => {
    const res = await apiClient.get<any>('/ExpenseReimbursement/Request/Request/GetRequestData', { params });
    if (Array.isArray(res.data)) return res.data as ExpenseRequestRecord[];
    if (Array.isArray(res.data?.data)) return res.data.data as ExpenseRequestRecord[];
    if (Array.isArray(res.data?.records)) return res.data.records as ExpenseRequestRecord[];
    return [];
  },
};

export default expenseApi;

