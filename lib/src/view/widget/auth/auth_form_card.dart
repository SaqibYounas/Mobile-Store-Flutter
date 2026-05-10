import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/view/widget/auth/auth_error_banner.dart';
import 'package:e_commerce_flutter/src/view/widget/auth/auth_gradient_submit.dart';
import 'package:e_commerce_flutter/src/view/widget/auth/auth_text_field.dart';

/// White card with the email / password (and optional name) inputs.
/// Toggles between login and register based on [isLogin]. Surfaces an
/// error banner when [error] is non-null.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    super.key,
    required this.formKey,
    required this.isLogin,
    required this.isLoading,
    required this.error,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onToggle,
    required this.onForgot,
  });

  final GlobalKey<FormState> formKey;
  final bool isLogin;
  final bool isLoading;
  final String? error;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final VoidCallback onToggle;
  final VoidCallback onForgot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLogin ? 'Welcome Back' : 'Create Account',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isLogin
                  ? 'Sign in to continue shopping'
                  : 'Join TrendNest in a few taps',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 22),
            if (!isLogin) ...[
              AuthTextField(
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
                controller: nameController,
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 14),
            ],
            AuthTextField(
              label: 'Email Address',
              icon: Icons.alternate_email_rounded,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v != null && v.contains('@'))
                  ? null
                  : 'Enter a valid email',
            ),
            const SizedBox(height: 14),
            AuthTextField(
              label: 'Password',
              icon: Icons.lock_open_rounded,
              controller: passwordController,
              isPassword: true,
              validator: (v) =>
                  (v != null && v.length >= 6) ? null : 'Minimum 6 characters',
            ),
            if (isLogin)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onForgot,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 6),
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            if (error != null) ...[
              const SizedBox(height: 8),
              AuthErrorBanner(message: error!),
            ],
            const SizedBox(height: 22),
            AuthGradientSubmit(
              text: isLogin ? 'SIGN IN' : 'CREATE ACCOUNT',
              isLoading: isLoading,
              onPressed: onSubmit,
            ),
            const SizedBox(height: 14),
            Center(
              child: TextButton(
                onPressed: onToggle,
                child: RichText(
                  text: TextSpan(
                    text: isLogin
                        ? "Don't have an account? "
                        : 'Already a member? ',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                    children: [
                      TextSpan(
                        text: isLogin ? 'Register' : 'Login',
                        style: const TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
