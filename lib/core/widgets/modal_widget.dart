import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../../modules/app_version/models/app_version_model.dart';

class AppModal {
  AppModal._();

  static void show({
    required BuildContext context,
    required String message,
    IconData icon = Icons.error_outline_rounded,
    Color iconColor = Colors.grey,
    String? primaryLabel,
    VoidCallback? onPrimary,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 48, color: iconColor),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (secondaryLabel != null && onSecondary != null)
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onSecondary();
                        },
                        child: Text(secondaryLabel),
                      ),
                    ),
                  if (primaryLabel != null && onPrimary != null)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onPrimary();
                        },
                        child: Text(primaryLabel),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.withValues(alpha: 0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showNotificationActivationModal({
    required BuildContext context,
    required VoidCallback onActivate,
    VoidCallback? onDismiss,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_active_rounded,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aktifkan Notifikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Aktifkan notifikasi agar Anda tidak ketinggalan informasi penting seputar perjalanan dan promo terbaru.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.muted : Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onActivate();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Aktifkan Sekarang',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onDismiss != null) onDismiss();
                  },
                  child: Text(
                    'Nanti Saja',
                    style: TextStyle(
                      color: isDark ? AppColors.muted : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showAppUpdate({
    required BuildContext context,
    required AppVersionData data,
    VoidCallback? onDismissed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isForced = data.forceUpdate;
    final message = data.description.isNotEmpty
        ? data.description
        : 'Tersedia versi ${data.version} baru.\n'
              'Perbarui sekarang untuk pengalaman terbaik.';

    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: !isForced,
      builder: (context) => PopScope(
        canPop: !isForced,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.system_update_rounded,
                      size: 48,
                      color: isDark ? AppColors.primary : AppColors.ink,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          if (!isForced) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                          final uri = Uri.parse(data.url);
                          if (data.url.isNotEmpty && await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            debugPrint(
                              'Could not launch update url: ${data.url}',
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Update Sekarang'),
                      ),
                    ),
                    if (!isForced) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            if (onDismissed != null) onDismissed();
                          },
                          child: Text(
                            'Nanti Saja',
                            style: TextStyle(
                              color: isDark ? AppColors.muted : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isForced)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      if (onDismissed != null) onDismissed();
                    },
                    icon: const Icon(Icons.close_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
