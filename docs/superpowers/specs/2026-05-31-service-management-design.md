# Design Spec: Service Management Module

**Date:** 2026-05-31
**Topic:** Core Service & Queue Management
**Status:** In Review

## 1. Overview
The Service Management module is the heart of the POS system. It tracks the lifecycle of a vehicle from entry (queue) to completion. It handles service orders, labor/part tracking, and status transitions.

## 2. Domain Model

### Entities & Value Objects (Freezed)
*   **`ServiceOrder`** (Entity):
    *   `id`: String
    *   `vehicleInfo`: `VehicleInfo` (Value Object)
    *   `complaint`: String
    *   `mechanicName`: String?
    *   `status`: `ServiceStatus` (Enum: `antri`, `dikerjakan`, `selesai`, `siapDiambil`)
    *   `items`: List<`ServiceItem`>
    *   `createdAt`: DateTime
    *   `updatedAt`: DateTime
    *   `completedAt`: DateTime?
    *   `readyAt`: DateTime?
    *   *Computed*: `totalEstimation` (Sum of all items)

*   **`VehicleInfo`** (Value Object):
    *   `plateNumber`: String
    *   `ownerName`: String
    *   `ownerPhone`: String
    *   `vehicleType`: String
    *   `vehicleBrand`: String?
    *   `vehicleModel`: String?

*   **`ServiceItem`** (Sealed/Union):
    *   **`LaborItem`**: `name`, `price`
    *   **`PartItem`**: `name`, `quantity`, `unitPrice`
    *   *Computed*: `subtotal`

### Status Transitions (Domain Logic)
Transitions must be sequential and validated (only moving forward for now):
1.  `antri` -> `dikerjakan`
2.  `dikerjakan` -> `selesai`
3.  `selesai` -> `siapDiambil`

## 3. Data Layer
*   **`ServiceRepository`**: Abstract interface for CRUD operations.
*   **`MockServiceDataSource`**: In-memory implementation for the MVP. Uses a singleton state to persist data during the session.

## 4. Presentation Layer (BLoC)
*   **`ServiceBloc`**:
    *   *Events*: `FetchServices`, `AddServiceOrder`, `UpdateServiceStatus`, `AddServiceItem`, `RemoveServiceItem`, `UpdateServiceItem`.
    *   *States*: `ServiceLoading`, `ServiceLoaded`, `ServiceOperationSuccess`, `ServiceError`.
    *   *Note*: Success feedback (snackbars) should use `ServiceOperationSuccess` while preserving the current list in the UI.

## 5. UI Components
*   **Dashboard List**: Filterable list of active service orders with status badges.
*   **New Service Form**: Input for `VehicleInfo` and initial complaint.
*   **Service Detail Page**: 
    *   Displays vehicle and owner info.
    *   Section to add/remove `ServiceItem`s.
    *   Real-time "Total Estimation" display.
    *   Status transition buttons (e.g., "Mulai Kerjakan", "Selesaikan").

## 6. Future Extensibility
The use of the `VehicleInfo` value object allows us to introduce a `Vehicle` entity and `vehicleId` later without breaking the `ServiceOrder` structure. The `ServiceItem` union type allows adding new item types (e.g., `DiscountItem`) easily.
