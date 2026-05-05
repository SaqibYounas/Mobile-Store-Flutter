import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/auth_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_toast.dart';
import 'package:e_commerce_flutter/src/core/services/auth_service.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';
import 'package:e_commerce_flutter/src/view/widget/gradient_button.dart';

class EmailUpdateScreen extends StatefulWidget {
  const EmailUpdateScreen({super.key});

  @override
  State<EmailUpdateScreen> createState() => _EmailUpdateScreenState();
}

class _EmailUpdateScreenState extends State<EmailUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newEmail = TextEditingController();
  bool _verificationSent = false;

  AuthController get _auth => Get.put(AuthController());

  @override
  void dispose() {
    _newEmail.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final newEmail = _newEmail.text.trim();
    if (newEmail.toLowerCase() ==
        (SessionService.userEmail ?? '').toLowerCase()) {
      AppToast.error('Same email', 'Please enter a different email address.');
      return;
    }
    final ok = await _auth.requestEmailChange(newEmail);
    if (!mounted) return;
    if (ok) {
      setState(() => _verificationSent = true);
      AppToast.success(
        'Verification sent',
        'Confirm via the link sent to $newEmail.',
      );
    } else {
      AppToast.error(
        'Update failed',
        _auth.errorMessage.value ?? 'Please try again.',
      );
    }
  }

  Future<void> _refresh() async {
    await AuthService.syncEmailFromAuth();
    if (!mounted) return;
    AppToast.info(
      'Refreshed',
      'Your email is now ${SessionService.userEmail ?? '—'}.',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = SessionService.userEmail ?? '—';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Email'),
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? 0.30
                              : 0.04,
                        ),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.alternate_email_rounded,
                          color: AppColor.brandIndigo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Email',
                              style: TextStyle(
                                color: AppColor.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              currentEmail,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _newEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'New email address',
                    prefixIcon: Icon(Icons.mark_email_unread_outlined),
                  ),
                  validator: (v) => (v != null && v.contains('@'))
                      ? null
                      : 'Enter a valid email',
                ),
                const SizedBox(height: 18),
                Obx(() => GradientButton(
                      text: _verificationSent
                          ? 'Resend Verification'
                          : 'Send Verification Email',
                      isLoading: _auth.isLoading.value,
                      onPressed: _auth.isLoading.value ? null : _submit,
                    )),
                const SizedBox(height: 14),
                if (_verificationSent) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF0369A1)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Open the verification link from your inbox. After confirming, return here and tap "I\'ve verified" to refresh your profile.',
                            style: TextStyle(color: Color(0xFF075985)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('I\'ve verified — refresh now'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
