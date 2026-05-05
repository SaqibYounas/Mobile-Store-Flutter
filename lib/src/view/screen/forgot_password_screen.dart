import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_toast.dart';
import 'package:e_commerce_flutter/src/view/widget/gradient_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _emailSent = false;

  AuthController get _auth => Get.put(AuthController());

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = await _auth.sendPasswordReset(_email.text.trim());
    if (!mounted) return;
    if (ok) {
      setState(() => _emailSent = true);
      AppToast.success(
        'Email sent',
        'Check your inbox for the password reset link.',
      );
    } else {
      AppToast.error(
        'Could not send',
        _auth.errorMessage.value ?? 'Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.brandIndigo.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColor.brandIndigo,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Reset your password',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter the email you signed up with. We\'ll send a secure link you can use to choose a new password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.textSecondary),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => (v != null && v.contains('@'))
                      ? null
                      : 'Enter a valid email',
                ),
                const SizedBox(height: 22),
                Obx(() => GradientButton(
                      text: _emailSent ? 'Resend Link' : 'Send Reset Link',
                      isLoading: _auth.isLoading.value,
                      onPressed: _auth.isLoading.value ? null : _submit,
                    )),
                const SizedBox(height: 18),
                if (_emailSent)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.mark_email_read_rounded,
                            color: Color(0xFF16A34A)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Check your inbox (and spam folder). The reset link expires in a few minutes.',
                            style: TextStyle(color: Color(0xFF14532D)),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Back to sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
