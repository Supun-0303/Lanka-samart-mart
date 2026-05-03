import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_models.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final existingIndex = state.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      // Product already in cart, increase quantity
      final updatedCart = [...state];
      updatedCart[existingIndex] = CartItem(
        productId: product.id,
        product: product,
        quantity: updatedCart[existingIndex].quantity + 1,
      );
      state = updatedCart;
    } else {
      // New product, add to cart
      state = [...state, CartItem(productId: product.id, product: product)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    final updatedCart = state.map((item) {
      if (item.productId == productId) {
        return CartItem(
          productId: item.productId,
          product: item.product,
          quantity: quantity,
        );
      }
      return item;
    }).toList();
    
    state = updatedCart;
  }

  void clearCart() {
    state = [];
  }

  double getTotalPrice() {
    return state.fold(0.0, (total, item) => total + item.totalPrice);
  }

  int getCartItemCount() {
    return state.fold(0, (count, item) => count + item.quantity);
  }
}

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (total, item) => total + item.totalPrice);
});

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (count, item) => count + item.quantity);
});
