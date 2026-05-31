import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/service/domain/repositories/service_repository.dart';
import '../../features/service/data/repositories/service_repository_impl.dart';
import '../../features/service/presentation/bloc/service_bloc.dart';
import '../../features/cashier/domain/repositories/cashier_repository.dart';
import '../../features/cashier/data/repositories/cashier_repository_impl.dart';
import '../../features/cashier/presentation/bloc/cashier_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/reports/presentation/bloc/reports_bloc.dart';
import '../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../features/inventory/data/repositories/inventory_repository_impl.dart';
import '../../features/inventory/presentation/bloc/inventory_bloc.dart';
import '../database/local_database.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database
  sl.registerLazySingleton(() => LocalDatabase());

  // Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Features - Service
  // Bloc
  sl.registerFactory(() => ServiceBloc(repository: sl(), inventoryRepository: sl()));
  
  // Repository
  sl.registerLazySingleton<ServiceRepository>(() => ServiceRepositoryImpl(dbProvider: sl()));

  // Features - Cashier
  // Bloc
  sl.registerFactory(
    () => CashierBloc(
      cashierRepository: sl(),
      serviceRepository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<CashierRepository>(() => CashierRepositoryImpl(dbProvider: sl()));

  // Features - Dashboard
  // Bloc
  sl.registerFactory(
    () => DashboardBloc(
      serviceRepository: sl(),
      cashierRepository: sl(),
    ),
  );

  // Features - Reports
  // Bloc
  sl.registerFactory(
    () => ReportsBloc(
      serviceRepository: sl(),
      cashierRepository: sl(),
    ),
  );

  // Features - Inventory
  // Bloc
  sl.registerFactory(() => InventoryBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImpl(dbProvider: sl()));
}
