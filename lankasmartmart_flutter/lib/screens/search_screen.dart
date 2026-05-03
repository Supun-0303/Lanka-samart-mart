import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final searchController = TextEditingController();
    final searchResults = ValueNotifier<List>(products);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          searchController.clear();
                          searchResults.value = products;
                        },
                        child: const Icon(Icons.clear),
                      )
                    : null,
              ),
              onChanged: (query) {
                if (query.isEmpty) {
                  searchResults.value = products;
                } else {
                  searchResults.value = products
                      .where(
                        (p) =>
                            p.name.toLowerCase().contains(
                              query.toLowerCase(),
                            ) ||
                            p.description.toLowerCase().contains(
                              query.toLowerCase(),
                            ),
                      )
                      .toList();
                }
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: searchResults,
              builder: (context, results, child) {
                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_outlined,
                          size: 80,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'No products found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: results[index],
                      onAddToCart: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${results[index].name} added to cart',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
