import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/secure_service.dart';
import '../../../core/widgets/modal_widget.dart';
import '../../../modules/app_version/widgets/app_update_gate.dart';
import '../../../routes/app_router.dart';

class MainNavigation extends ConsumerStatefulWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  static const _tabs = [
    _NavTab(
      path: AppRoutes.home,
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _NavTab(
      path: AppRoutes.orders,
      label: 'Orders',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
    ),
    _NavTab(
      path: AppRoutes.cart,
      label: 'Cart',
      icon: Icons.shopping_cart_outlined,
      selectedIcon: Icons.shopping_cart_rounded,
    ),
    _NavTab(
      path: AppRoutes.profile,
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation>
    with WidgetsBindingObserver {
  bool _hasCheckedNotification = false;
  DateTime? _lastBackPressTime;

  static const _exitSnackBarDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkAndShowNotificationPrompt();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionsOnResume();
    }
  }

  Future<void> _checkPermissionsOnResume() async {
    final isLoggedIn = ref.read(authProvider).isLoggedIn;
    if (!isLoggedIn) return;

    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.checkActualLocationPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onTabSelected(int index) {
    final path = MainNavigation._tabs[index].path;
    if (GoRouterState.of(context).matchedLocation != path) {
      context.go(path);
    }
  }

  void _handleBackPress() {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    if (currentLocation != AppRoutes.home) {
      context.go(AppRoutes.home);
    } else {
      final now = DateTime.now();
      if (_lastBackPressTime == null ||
          now.difference(_lastBackPressTime!) > _exitSnackBarDuration) {
        _lastBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tekan kembali lagi untuk keluar'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            duration: _exitSnackBarDuration,
          ),
        );
      } else {
        SystemNavigator.pop();
      }
    }
  }

  Future<void> _checkAndShowNotificationPrompt() async {
    if (_hasCheckedNotification) return;
    _hasCheckedNotification = true;

    try {
      final isLoggedIn = ref.read(authProvider).isLoggedIn;
      if (!isLoggedIn) return;

      final secureStorage = ref.read(secureStorageProvider);

      final settings = await const NotificationService()
          .getNotificationSettings();
      if (NotificationService.isAuthorized(settings)) {
        await secureStorage.saveNotificationPermissionGranted();
        return;
      }

      final wasGranted = await secureStorage.isNotificationPermissionGranted();
      if (wasGranted) return;

      await Future.delayed(const Duration(milliseconds: 300));
      final retrySettings = await const NotificationService()
          .getNotificationSettings();
      if (NotificationService.isAuthorized(retrySettings)) {
        await secureStorage.saveNotificationPermissionGranted();
        return;
      }

      if (mounted) {
        AppModal.showNotificationActivationModal(
          context: context,
          onActivate: () async {
            try {
              final service = const NotificationService();

              final settings = await service.requestPermission();

              debugPrint('NOTIFICATION AUTH: ${settings.authorizationStatus}');

              // Beri waktu APNs mendaftarkan device
              await Future.delayed(const Duration(seconds: 1));

              final apnsToken = await service.getApnsToken();

              debugPrint('APNS TOKEN: $apnsToken');

              final fcmToken = await service.getFcmToken();

              debugPrint('FCM TOKEN: $fcmToken');

              if (NotificationService.isAuthorized(settings)) {
                await secureStorage.saveNotificationPermissionGranted();
              }
            } on PlatformException catch (e) {
              debugPrint('Notification permission error: $e');
            } catch (e, stackTrace) {
              debugPrint('Notification error: $e');
              debugPrintStack(stackTrace: stackTrace);
            }
          },
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Notification prompt check failed: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ref.listen<AuthState>(authProvider, (previous, next) {
      final wasLoggedOut = previous?.isLoggedIn == false || previous == null;
      final isLoggedInNow = next.isLoggedIn;

      if (wasLoggedOut && isLoggedInNow) {
        _hasCheckedNotification = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _checkAndShowNotificationPrompt();
          }
        });
      }
    });

    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (bool? result, _) => _handleBackPress(),
      child: Scaffold(
        body: Stack(children: [widget.child, const AppUpdateGate()]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: widget._currentIndex(context),
          onDestinationSelected: _onTabSelected,
          backgroundColor: isDark ? AppColors.cardDark : AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.12),
          destinations: [
            for (final tab in MainNavigation._tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _NavTab {
  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _NavTab({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}
