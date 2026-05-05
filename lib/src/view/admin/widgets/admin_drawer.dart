import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';
import 'package:e_commerce_flutter/src/view/admin/admin_orders_screen.dart';

/// Side drawer for the admin shell. Header shows admin profile, body has
/// nav links to Products / Orders, footer has Logout.
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const _AdminDrawerHeader(),
            ListTile(
              leading: const Icon(
                Icons.inventory_2_rounded,
                color: AppColor.brandIndigo,
              ),
              title: const Text('Products'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.receipt_long_rounded,
                color: AppColor.brandIndigo,
              ),
              title: const Text('Orders'),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const AdminOrdersScreen());
              },
            ),
            const Spacer(),
            const Divider(),
            _LogoutTile(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _AdminDrawerHeader extends StatelessWidget {
  const _AdminDrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.brandIndigoDeep, AppColor.brandPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 28,
              child: Icon(
                Icons.admin_panel_settings_rounded,
                color: AppColor.brandIndigo,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            SessionService.userName ?? 'Admin',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            SessionService.userEmail ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout_rounded, color: Colors.red),
      title: const Text('Logout'),
      onTap: () async {
        final auth = Get.put(AuthController());
        await auth.signOut();
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.auth,
          (_) => false,
        );
      },
    );
  }
}
