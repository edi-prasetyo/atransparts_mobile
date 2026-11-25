import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_card_widget.dart';
import '../widgets/order_empty_widget.dart';
import '../widgets/order_tab_bar.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pendingOrders = ref.watch(pendingOrdersProvider);
    final deliveredOrders = ref.watch(deliveredOrdersProvider);
    final finishedOrders = ref.watch(finishedOrdersProvider);
    final cancelledOrders = ref.watch(cancelledOrdersProvider);

    final ordersList = [
      pendingOrders,
      deliveredOrders,
      finishedOrders,
      cancelledOrders,
    ];

    final emptyMessages = [
      'Belum ada pesanan pending',
      'Belum ada pesanan dikirim',
      'Belum ada pesanan selesai',
      'Tidak ada pesanan dibatalkan',
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              )
            : null,
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          OrderTabBar(
            tabController: _tabController,
            pendingCount: pendingOrders.length,
            deliveredCount: deliveredOrders.length,
            finishedCount: finishedOrders.length,
            cancelledCount: cancelledOrders.length,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(4, (index) {
                final orders = ordersList[index];
                if (orders.isEmpty) {
                  return OrderEmptyWidget(
                    message: emptyMessages[index],
                    onStartShopping: () => context.go(AppRoutes.products),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderCardWidget(
                      order: order,
                      onTap: () {
                        context.push('/orders/detail/${order.id}');
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}