# Refactoring Navigation & Data Input Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor data input flows (Add Stock, Add Transaction/Payment, Add Service, Add Service Item) from modal dialogs to dedicated screens with clear routing.

**Architecture:** Presentation layer routing and screen changes. Logic remains in the same BLoCs. Forms move from dialog widgets to full-screen scaffold widgets.

**Tech Stack:** Flutter, go_router, flutter_bloc.

---

### Task 1: Identify and Create New Screens

**Files:**
- Create: `lib/features/inventory/presentation/pages/add_inventory_page.dart`
- Create: `lib/features/cashier/presentation/pages/checkout_page.dart`
- Create: `lib/features/service/presentation/pages/add_service_page.dart`
- Create: `lib/features/service/presentation/pages/add_service_item_page.dart`

- [ ] **Step 1: Create AddInventoryPage**
Refactor the logic from `_showAddItemDialog` in `inventory_page.dart` to a new `StatelessWidget` with a `Scaffold` containing the form.
It should take the BLoC from context or be provided by the router.

- [ ] **Step 2: Create CheckoutPage**
Refactor `CheckoutDialog` from `lib/features/cashier/presentation/widgets/checkout_dialog.dart` into `lib/features/cashier/presentation/pages/checkout_page.dart`.
Update to use `Scaffold` instead of `AlertDialog`.

- [ ] **Step 3: Create AddServicePage**
Refactor the logic from `_showAddServiceDialog` in `service_page.dart` into `lib/features/service/presentation/pages/add_service_page.dart`.
Update to use `Scaffold`.

- [ ] **Step 4: Create AddServiceItemPage**
Refactor the logic from `_showAddItemDialog` in `service_detail_page.dart` into `lib/features/service/presentation/pages/add_service_item_page.dart`.
Update to use `Scaffold`. Need to pass the `serviceId` as a parameter.

---

### Task 2: Update Application Router

**Files:**
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Define New Routes**
Add the following routes to `appRouter`, ensuring they have the correct `BlocProvider`s:
- `/inventory/add` -> `AddInventoryPage` (Needs `InventoryBloc`)
- `/cashier/checkout/:id` -> `CheckoutPage` (Needs `CashierBloc` and the specific order data. To avoid passing complex objects via URL, fetch the order inside the page using the ID from `CashierBloc` state or `ServiceRepository`.)
- `/services/add` -> `AddServicePage` (Needs `ServiceBloc`)
- `/services/:id/add_item` -> `AddServiceItemPage` (Needs `ServiceBloc` and `InventoryBloc`)

*Note: Since they are top-level features or nested within shells, determine the best place (e.g., as sub-routes of their respective branches or global routes).*

---

### Task 3: Replace Dialog Invocations with Routing

**Files:**
- Modify: `lib/features/inventory/presentation/pages/inventory_page.dart`
- Modify: `lib/features/cashier/presentation/pages/cashier_page.dart`
- Modify: `lib/features/service/presentation/pages/service_page.dart`
- Modify: `lib/features/service/presentation/pages/service_detail_page.dart`

- [ ] **Step 1: Update InventoryPage**
Change the `FloatingActionButton` `onPressed` to `context.push('/inventory/add')`.
Remove the `_showAddItemDialog` method.

- [ ] **Step 2: Update CashierPage**
Change the `onTap` of `_PendingOrderCard` to `context.push('/cashier/checkout/${order.id}')`.
We might need to pass the `order` object. Since `go_router` prefers passing IDs and looking up data, we can pass the ID and let `CheckoutPage` retrieve the order from `CashierBloc`'s `PendingPaymentsLoaded` state.

- [ ] **Step 3: Update ServicePage**
Change the `FloatingActionButton` `onPressed` to `context.push('/services/add')`.
Remove the `_showAddServiceDialog` method.

- [ ] **Step 4: Update ServiceDetailPage**
Change the `TextButton.icon` (TAMBAH) `onPressed` to `context.push('/services/$serviceId/add_item')`.
Remove the `_showAddItemDialog` method.

---

### Task 4: Feedback via Snackbar and Navigation Back

**Files:**
- Modify: `lib/features/inventory/presentation/pages/add_inventory_page.dart`
- Modify: `lib/features/cashier/presentation/pages/checkout_page.dart`
- Modify: `lib/features/service/presentation/pages/add_service_page.dart`
- Modify: `lib/features/service/presentation/pages/add_service_item_page.dart`

- [ ] **Step 1: Implement BlocListeners for Success**
In each new Add/Checkout page, wrap the body in a `BlocListener` to listen for success states.
- On Success: show a Snackbar and call `context.pop()`.
- On Error: show a Snackbar with the error message.

*(Example for AddServicePage: listen for `ServiceOperationSuccess`)*

---

### Task 5: Cleanup and Verification

**Files:**
- Delete: `lib/features/cashier/presentation/widgets/checkout_dialog.dart` (if completely replaced)

- [ ] **Step 1: Delete unused widgets**
Remove `checkout_dialog.dart` as it's now a full page.

- [ ] **Step 2: Run flutter analyze**
Run `flutter analyze` to ensure no orphaned code or routing issues.

- [ ] **Step 3: Commit Changes**
Commit the refactoring.
````