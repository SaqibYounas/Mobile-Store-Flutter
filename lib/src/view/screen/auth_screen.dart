import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/view/widget/auth/auth_form_card.dart';
import 'package:e_commerce_flutter/src/view/widget/auth/auth_header.dart';

/// Sign-in / sign-up screen. Renders the gradient background and
/// composes [AuthHeader] + [AuthFormCard]. All input handling lives
/// inside [_AuthScreenBody].
class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) => const _AuthScreenBody();
}

class _AuthScreenBody extends StatefulWidget {
  const _AuthScreenBody();

  @override
  State<_AuthScreenBody> createState() => _AuthScreenBodyState();
}

class _AuthScreenBodyState extends State<_AuthScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  AuthController get _ctrl => Get.find<AuthController>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = _ctrl.isLogin.value
        ? await _ctrl.signIn(_email.text.trim(), _password.text.trim())
        : await _ctrl.signUp(
            _email.text.trim(),
            _password.text.trim(),
            _name.text.trim(),
          );
    if (!ok) return;
    Get.offAllNamed(_ctrl.isAdmin ? AppRoutes.admin : AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColor.gradientAuth),
          ),
          Positioned(
            top: -60,
            left: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthHeader(),
                    const SizedBox(height: 36),
                    Obx(
                      () => AuthFormCard(
                        formKey: _formKey,
                        isLogin: _ctrl.isLogin.value,
                        isLoading: _ctrl.isLoading.value,
                        error: _ctrl.errorMessage.value,
                        nameController: _name,
                        emailController: _email,
                        passwordController: _password,
                        onSubmit: _submit,
                        onToggle: _ctrl.toggleAuthMode,
                        onForgot: () => Get.toNamed(AppRoutes.forgotPassword),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
