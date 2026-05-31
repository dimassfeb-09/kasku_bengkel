# Design Spec: Reports & History Module

**Date:** 2026-05-31
**Topic:** Operational and Financial Reports
**Status:** Approved

## 1. Overview
The Reports module provides deep insights into the shop's performance. It allows the user to filter historical data to view revenue, transaction volume, and service popularity.

## 2. Requirements
*   **Filtering**: Daily, Weekly, Monthly, and Custom Range.
*   **Summary Metrics**: Total Revenue, Total Transactions, Average Transaction Value.
*   **History Table**: List of all `ServiceOrder` records with status filtering.
*   **Top Services**: Rank of most performed services (LaborItems).

## 3. Data Flow
1.  `ReportsBloc` calls `ServiceRepository.getActiveServices()` (actually all services).
2.  `ReportsBloc` calls `CashierRepository.getTransactionHistory()`.
3.  Logic filters both lists by the selected `DateTimeRange`.
4.  Calculates totals and counts.
5.  Emits `ReportsLoaded` with a `ReportMetrics` object.

## 4. Domain Model (DTO)
*   **`ReportMetrics`**:
    *   `revenue`: double
    *   `transactionCount`: int
    *   `averageValue`: double
    *   `topServices`: Map<String, int>
    *   `orders`: List<ServiceOrder>

## 5. UI Components
*   **Filter Header**: Chip-based presets or Date Range Picker.
*   **Metric Cards**: Highlights for Revenue, Count, and Avg.
*   **Order History List**: Expandable cards showing order summary and status.
*   **Top Services List**: Simple ranking list.
