# Clean Architecture Auth Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a Clean Architecture folder structure and a functional Auth/Login module using go_router, flutter_bloc, and get_it.

**Architecture:** Feature-First Clean Architecture. Layers are divided into Data, Domain, and Presentation within the 'auth' feature. Global configurations live in the 'core' directory.

**Tech Stack:** Flutter, go_router, flutter_bloc, get_it, dartz (for functional error handling).

---

### Task 1: Setup Dependencies and Directory Structure

**Files:**
- Modify: `pubspec.yaml`
- Create: Directory structure

- [ ] **Step 1: Add dependencies to pubspec.yaml**
```yaml
dependencies:
  flutter_bloc: ^9.0.0
  get_it: ^8.0.3
  go_router: ^14.7.2
  dartz: ^0.10.1
  equatable: ^2.0.7
```

- [ ] **Step 2: Run flutter pub get**
Run: `flutter pub get`

- [ ] **Step 3: Create directory structure**
Run:
```bash
mkdir -p lib/core/di lib/core/error lib/core/router lib/core/theme lib/core/usecases
mkdir -p lib/features/auth/data/datasources lib/features/auth/data/models lib/features/auth/data/repositories
mkdir -p lib/features/auth/domain/entities lib/features/auth/domain/repositories lib/features/auth/domain/usecases
mkdir -p lib/features/auth/presentation/bloc lib/features/auth/presentation/pages lib/features/auth/presentation/widgets
```

- [ ] **Step 4: Commit**
```bash
git add pubspec.yaml
git commit -m "chore: add dependencies and scaffold directories"
```

---

### Task 2: Implement Core Components

**Files:**
- Create: `lib/core/error/failures.dart`
- Create: `lib/core/usecases/usecase.dart`
- Create: `lib/core/router/app_router.dart`

- [ ] **Step 1: Define Failures**
File: `lib/core/error/failures.dart`
```dart
import 'package:equatable/equatable.dart';
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}
class ServerFailure extends Failure {}
```

- [ ] **Step 2: Define Base UseCase**
File: `lib/core/usecases/usecase.dart`
```dart
import 'package:dartz/dartz.dart';
import '../error/failures.dart';
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
class NoParams {}
```

- [ ] **Step 3: Setup GoRouter**
File: `lib/core/router/app_router.dart`
```dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Login Page Placeholder'))),
    ),
  ],
);
```

---

### Task 3: Auth Feature - Domain Layer

**Files:**
- Create: `lib/features/auth/domain/entities/user.dart`
- Create: `lib/features/auth/domain/repositories/auth_repository.dart`
- Create: `lib/features/auth/domain/usecases/login_usecase.dart`

- [ ] **Step 1: Create User Entity**
File: `lib/features/auth/domain/entities/user.dart`
```dart
import 'package:equatable/equatable.dart';
class User extends Equatable {
  final String id;
  final String username;
  const User({required this.id, required this.username});
  @override
  List<Object?> get props => [id, username];
}
```

- [ ] **Step 2: Create Auth Repository Interface**
File: `lib/features/auth/domain/repositories/auth_repository.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
}
```

- [ ] **Step 3: Create Login UseCase**
File: `lib/features/auth/domain/usecases/login_usecase.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;
  const LoginParams({required this.username, required this.password});
  @override
  List<Object?> get props => [username, password];
}
```

---

### Task 4: Auth Feature - Data Layer

**Files:**
- Create: `lib/features/auth/data/models/user_model.dart`
- Create: `lib/features/auth/data/datasources/auth_remote_data_source.dart`
- Create: `lib/features/auth/data/repositories/auth_repository_impl.dart`

- [ ] **Step 1: Create User Model (DTO)**
File: `lib/features/auth/data/models/user_model.dart`
```dart
import '../../domain/entities/user.dart';
class UserModel extends User {
  const UserModel({required super.id, required super.username});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], username: json['username']);
  }
}
```

- [ ] **Step 2: Create Remote Data Source**
File: `lib/features/auth/data/datasources/auth_remote_data_source.dart`
```dart
import '../models/user_model.dart';
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String username, String password) async {
    // Mocking network delay
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'admin' && password == 'admin') {
      return const UserModel(id: '1', username: 'admin');
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
```

- [ ] **Step 3: Implement Auth Repository**
File: `lib/features/auth/data/repositories/auth_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final user = await remoteDataSource.login(username, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

---

### Task 5: Dependency Injection & BLoC

**Files:**
- Create: `lib/core/di/injection_container.dart`
- Create: `lib/features/auth/presentation/bloc/auth_bloc.dart`

- [ ] **Step 1: Setup DI Container**
File: `lib/core/di/injection_container.dart`
```dart
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
}
```

- [ ] **Step 2: Implement Auth BLoC**
File: `lib/features/auth/presentation/bloc/auth_bloc.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/user.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  LoginSubmitted(this.username, this.password);
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase(LoginParams(username: event.username, password: event.password));
      result.fold(
        (failure) => emit(AuthFailure('Login Failed')),
        (user) => emit(AuthSuccess(user)),
      );
    });
  }
}
```

---

### Task 6: Presentation Layer & Integration

**Files:**
- Create: `lib/features/auth/presentation/pages/login_page.dart`
- Modify: `lib/main.dart`
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Create Login Page**
File: `lib/features/auth/presentation/pages/login_page.dart` (Simple UI implementation)

- [ ] **Step 2: Update App Router**
Point `/` to `LoginPage`.

- [ ] **Step 3: Update Main.dart**
Initialize DI and provide `AuthBloc` globally or at route level.
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
```
