import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_models.dart';

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Product>>(
  (ref) => FavoriteNotifier(),
);

class FavoriteNotifier extends StateNotifier<List<Product>> {
  FavoriteNotifier() : super([]);

  void addToFavorites(Product product) {
    if (!state.any((p) => p.id == product.id)) {
      state = [...state, product];
    }
  }

  void removeFromFavorites(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      removeFromFavorites(product.id);
    } else {
      addToFavorites(product);
    }
  }

  bool isFavorite(String productId) => state.any((p) => p.id == productId);

  void clearFavorites() {
    state = [];
  }
}

final favoriteCountProvider = Provider<int>((ref) {
  final favorites = ref.watch(favoriteProvider);
  return favorites.length;
});
