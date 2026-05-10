import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/controller/order_controller.dart';
import 'package:e_commerce_flutter/src/controller/admin_controller.dart';
import 'package:e_commerce_flutter/src/view/admin/admin_dashboard_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/auth_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/email_update_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/forgot_password_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/home_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/payment_screen.dart';
import 'package:e_commerce_flutter/src/view/screen/welcome_screen.dart';

/// Application routes - single source of truth for all navigation.
class AppRoutes {
  const AppRoutes._();

  // ---- Route names -------------------------------------------------------
  static const String welcome = '/welcome';
  static const String auth = '/auth';
  static const String forgotPassword = '/forgot-password';
  static const String emailUpdate = '/email-update';
  static const String home = '/home';
  static const String payment = '/payment';
  static const String admin = '/admin';

  // ---- Route definitions -------------------------------------------------
  static final List<GetPage> pages = [
    GetPage(
      name: welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: auth,
      page: () => const AuthScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: emailUpdate,
      page: () => const EmailUpdateScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductController>(() => ProductController());
        Get.lazyPut<OrderController>(() => OrderController());
      }),
    ),
    GetPage(
      name: payment,
      page: () => const PaymentScreen(),
    ),
    GetPage(
      name: admin,
      page: () => const AdminManageScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminController>(() => AdminController());
      }),
    ),
  ];
}
