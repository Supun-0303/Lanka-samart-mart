import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/order_provider.dart';
import '../utils/ui_utils.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'No orders yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ListTile(
                    title: Text(
                      'Order #${order.id.substring(0, 8).toUpperCase()}',
                    ),
                    subtitle: Text(UiUtils.formatDateTime(order.createdAt)),
                    trailing: Chip(
                      label: Text(UiUtils.getStatusText(order.status)),
                      backgroundColor: UiUtils.getStatusColor(order.status),
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      // Navigate to order details
                    },
                  ),
                );
              },
            ),
    );
  }
}
