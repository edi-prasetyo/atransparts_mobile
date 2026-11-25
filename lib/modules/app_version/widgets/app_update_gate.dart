import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/modal_widget.dart';
import '../controllers/app_version_controller.dart';

/// Memeriksa versi aplikasi saat dibuka. Jika tersedia pembaruan, tampilkan modal
/// sekali per sesi. Untuk `force_update`, modal tidak dapat ditutup hingga
/// pengguna membuka tautan update. Pada sesi berikutnya (proses baru), pemeriksaan
/// dijalankan kembali sehingga modal ditampilkan ulang bila belum diperbarui.
class AppUpdateGate extends ConsumerStatefulWidget {
  const AppUpdateGate({super.key});

  @override
  ConsumerState<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends ConsumerState<AppUpdateGate> {
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(appVersionControllerProvider).whenOrNull(
      data: (response) {
        if (_shown) return;
        final data = response?.data;
        if (data == null || !data.updateAvailable) return;
        _shown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            AppModal.showAppUpdate(context: context, data: data);
          }
        });
      },
      error: (error, _) {
        if (_shown) return;
        _shown = true;
        debugPrint('DEBUG: [APP_VERSION_CHECK] gagal tampilkan modal: $error');
      },
    );

    return const SizedBox.shrink();
  }
}
