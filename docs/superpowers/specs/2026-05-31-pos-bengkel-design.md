# Kasirku Bengkel (Automotive POS) Design Spec

**Date:** 2026-05-31
**Topic:** POS Application for Automotive Repair Shop
**Stack:** Flutter, go_router, flutter_bloc, get_it, dartz, freezed

## 1. Application Overview
A professional Point of Sale (POS) and management application for an automotive repair shop. It handles daily transactions, service queue management, and provides reporting capabilities.

## 2. Architecture & Tech Stack
*   **Architecture:** Feature-First Clean Architecture
    *   `presentation`: BLoC, Pages, Widgets
    *   `domain`: Entities, Use Cases, Repository Interfaces (Return `Either<Failure, Success>`)
    *   `data`: Models (Freezed), Data Sources, Repository Implementations
*   **State Management:** `flutter_bloc`
*   **Dependency Injection:** `get_it`
*   **Navigation:** `go_router` (Named routes with bottom navigation shell)
*   **Functional/Immutability:** `dartz` for error handling, `freezed` for immutable data classes

## 3. Design System & UX
*   **Theme Mode:** Light, clean, minimal.
*   **Color Palette:** Clean whites (`#FFFFFF`), subtle grays (`#F3F4F6`), deep blue accent (`#1E3A8A`) for trust/professionalism, or orange (`#F97316`) for action/automotive feel.
*   **Typography:** Google Fonts (e.g., Inter or Roboto). Clear hierarchy.
*   **Components:** Cards with 8px blur shadow, data tables, status badges.
*   **Spacing:** 8px grid system.
*   **Status Colors:**
    *   Antri: Orange
    *   Dikerjakan: Blue
    *   Selesai: Green
    *   Dibayar: Teal

## 4. Module Decomposition

### Feature 1: Dashboard (`lib/features/dashboard`)
*   **Goal:** High-level overview of daily operations.
*   **UI Components:** Summary metrics cards, weekly revenue bar chart, recent active services list.

### Feature 2: Cashier / Transactions (`lib/features/cashier`)
*   **Goal:** Process payments for completed services.
*   **UI Components:** List of 'Ready to Pay' orders, detailed bill view (services + parts), payment input (Cash, Transfer, QRIS), change calculator, print receipt action.
*   **State Flow:** Pending -> Dibayar -> Selesai.

### Feature 3: Service Management (`lib/features/service`)
*   **Goal:** Track vehicles entering the shop and manage their repair process.
*   **UI Components:** Incoming vehicle list, "Add Service" form, service detail view (adding parts/labor), cost estimator.
*   **State Flow:** Antri -> Dikerjakan -> Selesai -> Siap Diambil.

### Feature 4: Reports & History (`lib/features/reports`)
*   **Goal:** View past transactions and financial summaries.
*   **UI Components:** Date filters, summary metrics, paginated transaction table, top-selling services list.

## 5. Navigation Strategy (go_router)
Using a `ShellRoute` to maintain a consistent `BottomNavigationBar` across the 4 main modules:
*   `/dashboard`
*   `/cashier`
*   `/services`
*   `/reports`

## 6. Implementation Strategy
Due to the scope, the implementation will be broken down into individual plans per feature module, starting with the core Shell/Navigation and expanding to individual features iteratively.