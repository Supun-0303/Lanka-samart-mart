import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';
import '../models/order_models.dart';

class PaymentMethodScreen extends ConsumerWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final cards = ref.watch(paymentCardProvider);
    final selectedPayment = ValueNotifier<String>('cod');

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Cash on Delivery
            Card(
              child: RadioListTile(
                title: const Text('Cash on Delivery'),
                value: 'cod',
                groupValue: selectedPayment.value,
                onChanged: (value) {
                  selectedPayment.value = value.toString();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Card Payment
            ...cards.map((card) {
              return Card(
                child: RadioListTile(
                  title: Text('${card.cardType} ending in ${card.last4Digits}'),
                  subtitle: Text('${card.expiryMonth}/${card.expiryYear}'),
                  value: card.id,
                  groupValue: selectedPayment.value,
                  onChanged: (value) {
                    selectedPayment.value = value.toString();
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {
                // Navigate to add new card
              },
              child: const Text('Add New Card'),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Order Total
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text('Rs. ${cartTotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee:'),
                        const Text('Rs. 100.00'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rs. ${(cartTotal + 100).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Place order
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully!')),
                  );
                },
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
