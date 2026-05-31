import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/cashier/presentation/pages/cashier_page.dart';
import '../../features/service/presentation/pages/service_page.dart';
import '../../features/service/presentation/pages/service_detail_page.dart';
import '../../features/service/presentation/pages/add_service_page.dart';
import '../../features/service/presentation/pages/add_service_item_page.dart';
import '../../features/service/presentation/bloc/service_bloc.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/inventory/presentation/pages/add_inventory_page.dart';
import '../../features/inventory/presentation/bloc/inventory_bloc.dart';
import '../../features/cashier/presentation/pages/checkout_page.dart';
import '../../features/cashier/presentation/bloc/cashier_bloc.dart';
import '../di/injection_container.dart';
import 'scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) => const InventoryPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => BlocProvider.value(
                    value: sl<InventoryBloc>(),
                    child: const AddInventoryPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cashier',
              builder: (context, state) => const CashierPage(),
              routes: [
                GoRoute(
                  path: 'checkout/:id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return BlocProvider.value(
                      value: sl<CashierBloc>(),
                      child: CheckoutPage(orderId: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/services',
              builder: (context, state) => const ServicePage(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => BlocProvider.value(
                    value: sl<ServiceBloc>(),
                    child: const AddServicePage(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return BlocProvider.value(
                      value: sl<ServiceBloc>()..add(const FetchServices()),
                      child: ServiceDetailPage(serviceId: id),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'add_item',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return BlocProvider.value(
                          value: sl<ServiceBloc>(),
                          child: AddServiceItemPage(orderId: id),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reports',
              builder: (context, state) => const ReportsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
