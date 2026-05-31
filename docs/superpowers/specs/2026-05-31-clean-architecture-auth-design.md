# Design Spec: Clean Architecture with Auth Feature

**Date:** 2026-05-31
**Topic:** Initial Project Structure & Auth Module
**Stack:** Flutter, go_router, flutter_bloc, get_it

## 1. Architecture Overview
We are implementing a **Feature-First Clean Architecture**. This ensures that each feature (e.g., Auth) is self-contained with its own layers, while sharing common logic through a `core` package.

### Layers:
1. **Domain (Inner):** Pure Dart logic. Contains Entities, UseCases, and Repository interfaces.
2. **Data (Middle):** Implementation of the Domain's repositories. Handles Remote (API) and Local (Storage) data sources and DTO Models.
3. **Presentation (Outer):** UI layer. Contains BLoCs, Pages, and Widgets.

## 2. Directory Structure
```text
lib/
├── core/                  # Shared logic and configurations
│   ├── di/                # Dependency Injection (injection_container.dart)
│   ├── error/             # Failure and Exception classes
│   ├── router/            # GoRouter configuration (app_router.dart)
│   ├── theme/             # App styling and colors
│   └── usecases/          # Base UseCase abstract class
├── features/
│   └── auth/              # Auth Module
│       ├── data/
│       │   ├── datasources/ # remote_data_source.dart
│       │   ├── models/      # user_model.dart (DTO)
│       │   └── repositories/# auth_repository_impl.dart
│       ├── domain/
│       │   ├── entities/    # user.dart
│       │   ├── repositories/# auth_repository.dart (Interface)
│       │   └── usecases/    # login_usecase.dart
│       └── presentation/
│           ├── bloc/        # auth_bloc.dart
│           ├── pages/       # login_page.dart
│           └── widgets/     # login_form.dart
└── main.dart
```

## 3. Technology Integration

### Dependency Injection (get_it)
- A global `service_locator` (or `sl`) will be used.
- Registration happens in `lib/core/di/injection_container.dart`.
- Features register their own dependencies (Bloc -> UseCase -> Repository -> DataSource).

### Routing (go_router)
- Defined in `lib/core/router/app_router.dart`.
- Routes will map to feature pages.
- `GoRouter` allows for deep linking and easy parameter passing.

### State Management (flutter_bloc)
- `AuthBloc` will handle states: `AuthInitial`, `AuthLoading`, `AuthSuccess`, `AuthFailure`.
- Events: `LoginSubmitted`, `LogoutRequested`.

## 4. Initial Feature: Auth/Login
- **UseCase:** `Login(username, password)` returns `Either<Failure, User>`.
- **UI:** A simple login form with validation and loading indicator.
- **Mocking:** Initially, we will use a mock data source to simulate API calls.

## 5. Next Steps
1. Update `pubspec.yaml` with required dependencies.
2. Scaffold the directory structure.
3. Implement `core` components (Base UseCase, Failures, Router, DI).
4. Implement the `Auth` feature layers from Domain to Presentation.
