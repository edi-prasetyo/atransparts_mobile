import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingNavigationExtra extends Notifier<Map<String, dynamic>?> {
  @override
  Map<String, dynamic>? build() => null;

  void set(Map<String, dynamic>? value) {
    state = value;
  }
}

final pendingNavigationExtraProvider = NotifierProvider<PendingNavigationExtra, Map<String, dynamic>?>(
  PendingNavigationExtra.new,
);
