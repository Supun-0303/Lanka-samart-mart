import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Track Order')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order status timeline
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      _buildTimelineItem(
                        'Order Confirmed',
                        'Order received and confirmed',
                        true,
                        context,
                      ),
                      _buildTimelineItem(
                        'Processing',
                        'Your order is being packed',
                        true,
                        context,
                      ),
                      _buildTimelineItem(
                        'Out for Delivery',
                        'On the way to you',
                        false,
                        context,
                      ),
                      _buildTimelineItem(
                        'Delivered',
                        'Arriving today 2-3 PM',
                        false,
                        context,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Delivery address
              Text(
                'Delivery Address',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('123 Main Street'),
                      const Text('Colombo 7, Colombo'),
                      const SizedBox(height: AppSpacing.sm),
                      const Text('Phone: +94 123 456 789'),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.map),
                          label: const Text('View on Map'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTimelineItem(
    String title,
    String description,
    bool isCompleted,
    BuildContext context,
  ) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor:
                    isCompleted ? AppColors.primaryGreen : AppColors.borderGrey,
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle,
                  size: 16,
                  color: isCompleted ? Colors.black : AppColors.textGrey,
                ),
              ),
              if (title != 'Delivered')
                Container(width: 2, height: 40, color: AppColors.borderGrey),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textGrey),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ],
      );
}
