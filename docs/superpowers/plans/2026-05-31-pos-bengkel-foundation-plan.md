# Kasirku Bengkel Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the foundation for the Kasirku Bengkel POS application, including Freezed setup, Theme (Deep Blue/Orange), and a GoRouter Shell for bottom navigation.

**Architecture:** Feature-First Clean Architecture. This plan focuses on the `core` layer and the routing structure to support the 4 main modules (Dashboard, Kasir, Servis, Laporan).

**Tech Stack:** Flutter, go_router, flutter_bloc, get_it, freezed, json_serializable.

---

### Task 1: Setup Code Generation Dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add dependencies to pubspec.yaml**
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^9.0.0
  get_it: ^8.0.3
  go_router: ^14.7.2
  dartz: ^0.10.1
  equatable: ^2.0.7
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.9
  freezed: ^2.5.2
  json_serializable: ^8.1.0
```

- [ ] **Step 2: Run flutter pub get**
Run: `flutter pub get`
Expected: Dependencies resolve successfully.

- [ ] **Step 3: Commit**
```bash
git init
git remote add origin git@github.com:dimassfeb-09/kasku_bengkel.git
git add pubspec.yaml
git commit -m "chore: add freezed and json_serializable dependencies"
```

---

### Task 2: Implement App Theme

**Files:**
- Create: `lib/core/theme/app_theme.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Create App Theme**
File: `lib/core/theme/app_theme.dart`
```dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDeepBlue = Color(0xFF1E3A8A);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color backgroundGray = Color(0xFFF3F4F6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDeepBlue,
        primary: primaryDeepBlue,
        secondary: accentOrange,
        background: backgroundGray,
      ),
      scaffoldBackgroundColor: backgroundGray,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDeepBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Apply Theme in main.dart**
File: `lib/main.dart`
Update the `MyApp` widget:
```dart
import 'package:flutter/material.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kasirku Bengkel',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
```

- [ ] **Step 3: Commit**
```bash
git add lib/core/theme/app_theme.dart lib/main.dart
git commit -m "feat: implement deep blue and orange app theme"
```

---

### Task 3: Create Placeholder Pages for Modules

**Files:**
- Create: `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Create: `lib/features/cashier/presentation/pages/cashier_page.dart`
- Create: `lib/features/service/presentation/pages/service_page.dart`
- Create: `lib/features/reports/presentation/pages/reports_page.dart`

- [ ] **Step 1: Create Dashboard Page**
Run: `mkdir -p lib/features/dashboard/presentation/pages`
File: `lib/features/dashboard/presentation/pages/dashboard_page.dart`
```dart
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Dashboard Utama')),
    );
  }
}
```

- [ ] **Step 2: Create Cashier Page**
Run: `mkdir -p lib/features/cashier/presentation/pages`
File: `lib/features/cashier/presentation/pages/cashier_page.dart`
```dart
import 'package:flutter/material.dart';

class CashierPage extends StatelessWidget {
  const CashierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Kasir / Transaksi')),
    );
  }
}
```

- [ ] **Step 3: Create Service Page**
Run: `mkdir -p lib/features/service/presentation/pages`
File: `lib/features/service/presentation/pages/service_page.dart`
```dart
import 'package:flutter/material.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Manajemen Servis')),
    );
  }
}
```

- [ ] **Step 4: Create Reports Page**
Run: `mkdir -p lib/features/reports/presentation/pages`
File: `lib/features/reports/presentation/pages/reports_page.dart`
```dart
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Laporan & Riwayat')),
    );
  }
}
```

- [ ] **Step 5: Commit**
```bash
git add lib/features/*/presentation/pages/*.dart
git commit -m "feat: add placeholder pages for main modules"
```

---

### Task 4: Setup Shell Route (Bottom Navigation)

**Files:**
- Create: `lib/core/router/scaffold_with_nav_bar.dart`
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Create Scaffold with Bottom Nav**
File: `lib/core/router/scaffold_with_nav_bar.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasirku Bengkel'),
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'Kasir'),
          NavigationDestination(icon: Icon(Icons.build), label: 'Servis'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Laporan'),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
```

- [ ] **Step 2: Update App Router**
File: `lib/core/router/app_router.dart`
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/cashier/presentation/pages/cashier_page.dart';
import '../../features/service/presentation/pages/service_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
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
              path: '/cashier',
              builder: (context, state) => const CashierPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/services',
              builder: (context, state) => const ServicePage(),
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
```

- [ ] **Step 3: Commit**
```bash
git add lib/core/router/*.dart
git commit -m "feat: setup go_router shell route with bottom navigation"
```
