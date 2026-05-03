import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  final String orderId;

  const OrderConfirmationScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Order Confirmed!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Order #${orderId.substring(0, 8).toUpperCase()}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.schedule),
                        title: Text('Estimated Delivery'),
                        subtitle: Text('Today, 2-3 PM'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Delivery Contact'),
                        subtitle: Text('+94 123 456 789'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('Delivery Address'),
                        subtitle: Text('123 Main St, Colombo 7'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
                  },
                  child: const Text('Back to Home'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/order-history');
                  },
                  child: const Text('Track Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
