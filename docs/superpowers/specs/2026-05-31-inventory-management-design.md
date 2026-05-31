# Design Spec: Inventory & Stock Management

**Date:** 2026-05-31
**Topic:** Catalog and Stock Automation
**Status:** Approved

## 1. Overview
This module centralizes the management of Spareparts and Labor (Services). It ensures price consistency and automates stock level tracking.

## 2. Domain Model

### Entities (Freezed)
*   **`InventoryItem`**:
    *   `id`: String (UUID)
    *   `name`: String
    *   `type`: `ItemType` (Enum: `part`, `labor`)
    *   `sku`: String?
    *   `purchasePrice`: double (for profit tracking)
    *   `sellingPrice`: double
    *   `stock`: int (applicable only for `part`)
    *   `minStockLevel`: int (threshold for alerts)
    *   `createdAt`: DateTime

### Logic Rules
1.  **Deduction:** When a `PartItem` is added to a `ServiceOrder`, the corresponding `InventoryItem.stock` is decreased by the quantity added.
2.  **Restoration:** When a `PartItem` is removed from a `ServiceOrder` (or the order is canceled), the stock is added back to the inventory.
3.  **Labor:** Labor items have no stock tracking but are picked from the catalog to ensure price consistency.

## 3. Data Layer
*   **`InventoryRepository`**: CRUD for items, stock adjustment methods.
*   **Database:** New `inventory` table in SQLite.

## 4. UI/UX Changes
*   **Inventory Page:** A new tab/page to manage the catalog (Add/Edit/Search/Filter).
*   **Item Picker:** Replace the manual text fields in the "Tambah Item" dialog with a Searchable List or Dropdown from the Inventory catalog.

## 5. Dashboard Integration
*   Add a "Stok Kritis" indicator or list showing items where `stock <= minStockLevel`.
