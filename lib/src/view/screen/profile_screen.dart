import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_toast.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';
import 'package:e_commerce_flutter/src/view/widget/app_card.dart';
import 'package:e_commerce_flutter/src/view/widget/empty_state.dart';
import 'package:e_commerce_flutter/src/view/widget/profile/profile_hero.dart';
import 'package:e_commerce_flutter/src/view/widget/profile/profile_tile.dart';
import 'package:e_commerce_flutter/src/view/widget/profile/theme_toggle_tile.dart';

/// Profile tab — shows the user's name + email and quick actions for
/// updating email, resetting password, and signing out.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;

  String _name = '';
  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      final data = await _supabase
          .from('users')
          .select('name, email')
          .eq('id', user.id)
          .single();
      if (!mounted) return;
      setState(() {
        _name = (data['name'] ?? '').toString();
        _email = (data['email'] ?? '').toString();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Profile fetch error: $e');
    }
  }

  Future<void> _logout() async {
    await _supabase.auth.signOut();
    await SessionService.clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (_) => false);
  }

  Future<void> _openEmailUpdate() async {
    await Get.toNamed(AppRoutes.emailUpdate);
    if (mounted) _fetchUser();
  }

  Future<void> _openPasswordReset() async {
    if (_email.isEmpty) {
      AppToast.error('No email', 'Sign in again before resetting.');
      return;
    }
    await Get.toNamed(AppRoutes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    if (!SessionService.isLoggedIn) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.account_circle_outlined,
          title: 'You are browsing as a guest',
          subtitle: 'Sign in to manage your profile and orders.',
          action: ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.auth),
            icon: const Icon(Icons.login),
            label: const Text('Sign In'),
          ),
        ),
      );
    }
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          children: [
            ProfileHero(name: _name, email: _email),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ProfileTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Full Name',
                      subtitle: _name.isEmpty ? 'Not set' : _name,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ProfileTile(
                      icon: Icons.alternate_email_rounded,
                      title: 'Email',
                      subtitle: _email.isEmpty ? 'Not set' : _email,
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColor.textTertiary,
                      ),
                      onTap: _openEmailUpdate,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ProfileTile(
                      icon: Icons.lock_reset_rounded,
                      title: 'Reset Password',
                      subtitle: 'Receive a secure link via email',
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColor.textTertiary,
                      ),
                      onTap: _openPasswordReset,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const ThemeToggleTile(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: ProfileTile(
                  icon: Icons.logout_rounded,
                  iconColor: Colors.redAccent,
                  title: 'Logout',
                  subtitle: 'Sign out from this device',
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColor.textTertiary,
                  ),
                  onTap: _logout,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
