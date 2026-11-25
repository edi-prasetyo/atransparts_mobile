import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_router.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      body: SafeArea(
        bottom: false,
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'Gagal memuat profil',
              style: TextStyle(
                color: isDark ? AppColors.muted : Colors.grey[600],
              ),
            ),
          ),
          data: (profile) => _buildContent(context, ref, isDark, profile),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    ProfileModel? profile,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _buildHeader(context, isDark, profile),
        const SizedBox(height: 20),
        if (profile != null && profile.isTempoMember) ...[
          _buildTempoCard(context, ref, isDark),
          const SizedBox(height: 12),
        ],
        _buildMenuGroup(context, isDark, [
          _MenuItem(
            icon: Icons.receipt_long_rounded,
            label: 'Pesanan Saya',
            onTap: () => context.push(AppRoutes.orders),
          ),
          _MenuItem(
            icon: Icons.request_quote_rounded,
            label: 'Tagihan Saya',
            badge: 'Tempo',
            onTap: () => context.push(AppRoutes.bills),
          ),
          _MenuItem(
            icon: Icons.location_on_rounded,
            label: 'Alamat Tersimpan',
            onTap: () => context.push(AppRoutes.security),
          ),
        ]),
        const SizedBox(height: 12),
        _buildMenuGroup(context, isDark, [
          _MenuItem(
            icon: Icons.lock_outline_rounded,
            label: 'Keamanan',
            onTap: () => context.push(AppRoutes.security),
          ),
          _MenuItem(
            icon: Icons.password_rounded,
            label: 'Ubah Kata Sandi',
            onTap: () => context.push(AppRoutes.updatePassword),
          ),
          _MenuItem(
            icon: Icons.settings_outlined,
            label: 'Pengaturan Aplikasi',
            onTap: () => context.push(AppRoutes.settings),
          ),
        ]),
        const SizedBox(height: 12),
        _buildMenuGroup(context, isDark, [
          _MenuItem(
            icon: Icons.info_outline_rounded,
            label: 'Info Aplikasi',
            onTap: () => context.push(AppRoutes.appInfo),
          ),
          _MenuItem(
            icon: Icons.privacy_tip_outlined,
            label: 'Kebijakan Privasi',
            onTap: () => context.push(AppRoutes.privacy),
          ),
          _MenuItem(
            icon: Icons.description_outlined,
            label: 'Syarat & Ketentuan',
            onTap: () => context.push(AppRoutes.term),
          ),
          _MenuItem(
            icon: Icons.help_outline_rounded,
            label: 'Pusat Bantuan',
            onTap: () => context.push(AppRoutes.categoryHelp),
          ),
        ]),
        const SizedBox(height: 20),
        _buildLogoutButton(context, ref, isDark),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, ProfileModel? profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundImage: profile?.avatar != null
                ? NetworkImage(profile!.avatar!)
                : null,
            child: profile?.avatar == null
                ? Text(
                    _initials(profile?.name ?? 'U'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name.isNotEmpty == true ? profile!.name : 'Pengguna',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile?.email ?? '-',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.muted : Colors.grey[600],
                  ),
                ),
                if (profile?.memberType != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: profile!.isTempoMember
                          ? AppColors.warning.withValues(alpha: 0.12)
                          : AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      profile.isTempoMember ? 'Member Tempo' : 'Member Biasa',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: profile.isTempoMember
                            ? AppColors.warning
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempoCard(BuildContext context, WidgetRef ref, bool isDark) {
    return InkWell(
      onTap: () => context.push(AppRoutes.bills),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.request_quote_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tagihan Tempo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Lihat & bayar tagihan tempo Anda',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGroup(BuildContext context, bool isDark, List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == items.length - 1;
          return Column(
            children: [
              ListTile(
                onTap: item.onTap,
                leading: Icon(
                  item.icon,
                  size: 22,
                  color: AppColors.primary,
                ),
                title: Row(
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : AppColors.ink,
                      ),
                    ),
                    if (item.badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          item.badge!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.muted : Colors.grey[400],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  color: isDark
                      ? AppColors.muted.withValues(alpha: 0.15)
                      : AppColors.divider,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref, bool isDark) {
    return CustomButton(
      text: 'Keluar',
      variant: CustomButtonVariant.outline,
      foregroundColor: AppColors.danger,
      prefixIcon: Icons.logout_rounded,
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Keluar'),
            content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                ),
                child: const Text('Keluar'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await ref.read(authControllerProvider.notifier).logout();
          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        }
      },
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });
}