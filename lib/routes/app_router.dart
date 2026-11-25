import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'dart:developer' as dev;

import '../core/providers/auth_provider.dart';
import '../core/providers/pending_navigation_provider.dart';
import '../core/router/router_refresh_notifier.dart';

import '../modules/auth/controllers/auth_controller.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import '../modules/auth/pages/verify_page.dart';
import '../modules/auth/pages/forgot_password_page.dart';

import '../modules/home/pages/home_page.dart';
import '../modules/products/pages/product.dart';
import '../modules/products/pages/detail_product.dart';
import '../modules/carts/pages/cart_page.dart';
import '../modules/checkout/pages/checkout_page.dart';
import '../modules/payment/pages/select_payment.dart';
import '../modules/payment/pages/pay.dart';
import '../modules/orders/pages/order.dart';
import '../modules/orders/pages/order_detail.dart';
import '../modules/bills/pages/bill.dart';
import '../modules/bills/pages/detail_bill.dart';

import '../modules/profile/pages/app_setting_page.dart';
import '../modules/profile/pages/app_info_page.dart';
import '../modules/profile/pages/update_password_page.dart';
import '../modules/profile/pages/security_page.dart';
import '../modules/profile/pages/privacy_page.dart';
import '../modules/profile/pages/term_page.dart';
import '../modules/profile/pages/helps/category_help.dart';
import '../modules/profile/pages/helps/category_detail_help.dart';
import '../modules/profile/pages/profile_page.dart';

import '../main_navigation.dart';

// ==========================================================
// Nama & path route
// ==========================================================
class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const register = '/register';
  static const verify = '/verify';
  static const forgotPassword = '/forgot-password';

  static const home = '/home';
  static const products = '/products';
  static const productDetail = '/products/detail/:id';
  static const orders = '/orders';
  static const cart = '/cart';
  static const booking = '/booking';
  static const bookingDetail = '/booking/detail/:id';
  static const bookingInvoice = '/booking/invoice';
  static const profile = '/profile';
  static const checkout = '/checkout';
  static const routeDetail = '/route/detail/:id';
  static const payment = '/payment';
  static const success = '/success';

  static const shuttle = '/shuttle';
  static const form = '/form';
  static const shuttleResult = '/shuttle/result';
  static const voucher = '/voucher';
  static const settings = '/settings';
  static const appInfo = '/app-info';
  static const selectPayment = '/select-payment';
  static const pay = '/pay';
  static const orderDetail = '/orders/detail/:id';
  static const bills = '/bills';
  static const billDetail = '/bills/detail/:id';
  static const point = '/point';
  static const pointPreview = '/point/preview';
  static const pointPayment = '/point/payment';
  static const pointHistory = '/point/history';
  static const pointHistoryDetail = '/point/history/:id';
  static const pointPaymentWebview = '/point/payment/webview';
  static const myPoint = '/my-point';
  static const transactions = '/transactions';
  static const transactionsDetail = '/transactions/:id';
  static const transactionPayment = '/transaction/payment/:transactionId';
  static const transactionPaymentWebview = '/transaction/payment/webview';
  static const updatePassword = '/update-password';
  static const security = '/security';
  static const privacy = '/privacy';
  static const term = '/term';
  static const categoryHelp = '/category-help';
  static const categoryDetailHelp = '/category-detail-help';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

/// Daftar path yang WAJIB login untuk diakses.
/// Sesuai aturan App Store, guest boleh browsing bebas — login baru
/// diwajibkan saat aksi tertentu (misal checkout).
///
/// Saat ini masih prototype, jadi list dikosongkan (semua halaman terbuka).
/// Nanti kalau mau mulai mengunci halaman tertentu, tinggal tambahkan
/// path-nya di sini, contoh:
///
/// static const protectedPaths = [
///   AppRoutes.checkout,
///   AppRoutes.profile,
/// ];
class AuthGuard {
  AuthGuard._();

  static const List<String> protectedPaths = [
    AppRoutes.booking,
    AppRoutes.form,
    AppRoutes.point,
    AppRoutes.pointPreview,
    AppRoutes.pointPayment,
    AppRoutes.pointHistory,
    AppRoutes.pointHistoryDetail,
    AppRoutes.myPoint,
    AppRoutes.transactions,
    AppRoutes.transactionsDetail,
    AppRoutes.transactionPayment,
    AppRoutes.transactionPaymentWebview,
    AppRoutes.payment,
    AppRoutes.routeDetail,
    AppRoutes.booking,
    AppRoutes.bookingDetail,
    AppRoutes.bookingInvoice,
  ];

  static bool requiresLogin(String location) {
    return protectedPaths.any((path) => location.startsWith(path));
  }
}

// ==========================================================
// ROUTER PROVIDER — satu-satunya sumber GoRouter di seluruh app
// ==========================================================
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshNotifierProvider);

  ref.read(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true, // set false saat production
    refreshListenable: refreshNotifier,

    redirect: (BuildContext context, GoRouterState state) {
      debugPrint('========== ROUTER REDIRECT ==========');
      debugPrint('Location: ${state.matchedLocation}');
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isLoggedIn;
      final isVerified = authState.isVerified;
      final isLoading = authState.isLoading;
      debugPrint(
        'isLoggedIn: $isLoggedIn, isVerified: $isVerified, isLoading: $isLoading',
      );
      final location = state.matchedLocation;

      // Tunggu pengecekan verifikasi dari server selesai agar tidak redirect
      // berdasarkan data tersimpan yang bisa menyesatkan.
      if (isLoading) {
        debugPrint('REDIRECT: null (loading verification from server)');
        return null;
      }

      // Halaman auth yang hanya untuk guest/belum login.
      final goingToAuth =
          location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.forgotPassword;

      // Verify page hanya boleh diakses jika sedang login (meski belum verifikasi).
      // Jika tidak login dan sedang di verify page, lempar ke login.
      if (!isLoggedIn && location == AppRoutes.verify) {
        debugPrint('REDIRECT: to /login (tidak login, mengakses /verify)');
        return AppRoutes.login;
      }

      // 1. Guest yang mengakses halaman butuh login -> paksa ke /login.
      if (!isLoggedIn && AuthGuard.requiresLogin(location)) {
        final extra = state.extra as Map<String, dynamic>?;
        dev.log('🔒 Redirect to login: $location, extra: $extra');
        if (extra != null && extra.isNotEmpty) {
          ref
              .read(pendingNavigationExtraProvider.notifier)
              .set(Map.from(extra));
          dev.log('💾 Stored pending extra: $extra');
        }
        debugPrint('REDIRECT: to /login');
        return '${AppRoutes.login}?redirect=$location';
      }

      // 2. Sudah login tapi belum verifikasi OTP -> paksa ke /verify
      //    (kecuali memang sudah berada di /verify).
      if (isLoggedIn && isVerified != 1 && location != AppRoutes.verify) {
        final email = state.uri.queryParameters['email'];
        final target = email != null && email.isNotEmpty
            ? '${AppRoutes.verify}?email=$email'
            : AppRoutes.verify;
        debugPrint('REDIRECT: to $target (belum terverifikasi)');
        return target;
      }

      // 3. Sudah login & terverifikasi -> jangan biarkan kembali ke halaman auth
      //    (login/register/forgot). (/verify dikecualikan agar verify_page masih
      //    bisa memanggil login() untuk kirim fcm_token sebelum pindah ke home.)
      if (isLoggedIn && isVerified == 1 && goingToAuth) {
        final redirectTo = state.uri.queryParameters['redirect'];
        if (redirectTo != null && redirectTo.isNotEmpty) {
          return null;
        }
        debugPrint('REDIRECT: to /home (terverifikasi)');
        return AppRoutes.home;
      }

      debugPrint('REDIRECT: null (no redirect)');
      return null;
    },
    routes: [
      // ---------------- AUTH ----------------
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) =>
            LoginPage(redirectTo: state.uri.queryParameters['redirect']),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.verify,
        name: 'verify',
        builder: (context, state) => const VerifyPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const AppSettingPage(),
      ),

      GoRoute(
        path: AppRoutes.products,
        name: 'products',
        builder: (context, state) => const ProductPage(),
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'productDetail',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return ProductDetailPage(productId: id);
        },
      ),

      GoRoute(
        path: AppRoutes.appInfo,
        name: 'appInfo',
        builder: (context, state) => const AppInfoPage(),
      ),

      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),

      GoRoute(
        path: AppRoutes.updatePassword,
        name: 'updatePassword',
        builder: (context, state) => const UpdatePasswordPage(),
      ),

      GoRoute(
        path: AppRoutes.selectPayment,
        name: 'selectPayment',
        builder: (context, state) => const SelectPaymentPage(),
      ),
      GoRoute(
        path: AppRoutes.pay,
        name: 'pay',
        builder: (context, state) => const PayPage(),
      ),

      GoRoute(
        path: AppRoutes.orderDetail,
        name: 'orderDetail',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return OrderDetailPage(orderId: id);
        },
      ),

      GoRoute(
        path: AppRoutes.bills,
        name: 'bills',
        builder: (context, state) => const BillPage(),
      ),
      GoRoute(
        path: AppRoutes.billDetail,
        name: 'billDetail',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return DetailBillPage(billId: id);
        },
      ),

      GoRoute(
        path: AppRoutes.security,
        name: 'security',
        builder: (context, state) => const SecurityPage(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        name: 'privacy',
        builder: (context, state) => const PrivacyPage(),
      ),
      GoRoute(
        path: AppRoutes.term,
        name: 'term',
        builder: (context, state) => const TermPage(),
      ),
      GoRoute(
        path: AppRoutes.categoryHelp,
        name: 'categoryHelp',
        builder: (context, state) => const CategoryHelpPage(),
      ),
      GoRoute(
        path: '${AppRoutes.categoryDetailHelp}/:id',
        name: 'categoryDetailHelp',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return CategoryDetailHelpPage(categoryId: id);
        },
      ),

      GoRoute(
        path: AppRoutes.pointPayment,
        name: 'pointPayment',
        builder: (context, state) {
          // Halaman payment Point untuk sementara dinonaktifkan.
          // Akan dibuat halaman khusus payment untuk Booking & Point
          // yang baru di iterasi selanjutnya.
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.construction_rounded,
                      size: 56,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Halaman pembayaran akan segera tersedia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // ---------------- SHELL: bottom navigation ----------------
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          debugPrint('========== ShellRoute BUILD: MainNavigation ==========');
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),

          GoRoute(
            path: AppRoutes.orders,
            name: 'orders',
            builder: (context, state) => const OrderPage(),
          ),

          GoRoute(
            path: AppRoutes.cart,
            name: 'cart',
            builder: (context, state) => const CartPage(),
          ),

          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan: ${state.error}')),
    ),
  );
});
