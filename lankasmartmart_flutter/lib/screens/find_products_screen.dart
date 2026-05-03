import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class FindProductsScreen extends ConsumerWidget {
  const FindProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              // Navigate to product list
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.cardGrey,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Center(
                        child: Icon(
                          _getCategoryIcon(category),
                          size: 40,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.capitalizeFirst,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Tap to view products',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.spa;
      case 'dairy':
        return Icons.local_grocery_store;
      case 'snacks':
        return Icons.fastfood;
      case 'groceries':
        return Icons.shopping_basket;
      default:
        return Icons.category;
    }
  }
}

extension on String {
  String get capitalizeFirst => '${this[0].toUpperCase()}${substring(1)}';
}
