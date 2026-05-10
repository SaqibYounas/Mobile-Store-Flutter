import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/constants/supabase_config.dart';
import 'package:e_commerce_flutter/src/controller/theme_controller.dart';
import 'package:e_commerce_flutter/src/core/app_theme.dart';
import 'package:e_commerce_flutter/src/core/services/auth_service.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  await SessionService.init();

  // Hydrate the user's profile so role-based routing works on cold start.
  if (AuthService.isLoggedIn) {
    try {
      await AuthService.currentProfile();
    } catch (_) {}
  }

  // Theme controller is created up-front so the saved mode is read before
  // the first frame.
  Get.put(ThemeController(), permanent: true);

  // Default first-launch flow goes through the welcome screen so users can
  // browse without signing in. Authenticated users skip straight to the
  // appropriate landing screen for their role.
  String initialRoute = AppRoutes.welcome;
  if (AuthService.isLoggedIn) {
    initialRoute = SessionService.isAdmin ? AppRoutes.admin : AppRoutes.home;
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        theme: AppTheme.lightAppTheme,
        darkTheme: AppTheme.darkAppTheme,
        themeMode: themeCtrl.mode.value,
        initialRoute: initialRoute,
        getPages: AppRoutes.pages,
      ),
    );
  }
}
