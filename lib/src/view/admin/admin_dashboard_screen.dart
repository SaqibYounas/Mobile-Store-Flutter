import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/controller/admin_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_toast.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_drawer.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_hero_header.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_product_form.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_product_row.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_search_bar.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/admin_stats_row.dart';

/// Admin shell — top-level scaffold for the dashboard. Composes the hero
/// header, stats row, search bar, and product list. Delegates each piece
/// to its dedicated widget under `admin/widgets/` for reusability.
class AdminManageScreen extends GetView<AdminController> {
  const AdminManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!SessionService.isAdmin) {
      return const _AccessDeniedRedirect();
    }

    return Scaffold(
      drawer: const AdminDrawer(),
      floatingActionButton: _AddProductFab(),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          _DashboardAppBar(controller: controller),
          SliverToBoxAdapter(child: AdminStatsRow(controller: controller)),
          SliverToBoxAdapter(
            child: AdminSearchBar(onChanged: controller.onSearchChanged),
          ),
        ],
        body: _ProductListBody(controller: controller),
      ),
    );
  }
}

/// Renders a brief loading view, then redirects non-admin users home.
class _AccessDeniedRedirect extends StatelessWidget {
  const _AccessDeniedRedirect();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(AppRoutes.home);
      AppToast.error(
        'Access Denied',
        'Only admin users can access this page.',
      );
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _AddProductFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColor.brandIndigo,
      foregroundColor: Colors.white,
      onPressed: () => AdminProductForm.show(context),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add Product'),
    );
  }
}

class _DashboardAppBar extends StatelessWidget {
  const _DashboardAppBar({required this.controller});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      pinned: false,
      floating: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: controller.fetchAdminProducts,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      flexibleSpace: const AdminHeroHeader(),
      expandedHeight: 170,
    );
  }
}

class _ProductListBody extends StatelessWidget {
  const _ProductListBody({required this.controller});

  final AdminController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.products.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.products.isEmpty) {
        return const _EmptyProducts();
      }
      return RefreshIndicator(
        onRefresh: controller.fetchAdminProducts,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          itemCount: controller.products.length,
          itemBuilder: (_, i) => AdminProductRow(
            product: controller.products[i],
            controller: controller,
          ),
        ),
      );
    });
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No products yet. Tap "Add Product" to create one.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textSecondary),
        ),
      ),
    );
  }
}
