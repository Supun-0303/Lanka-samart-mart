import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_models.dart';

// Sample products data provider
final productsProvider = StateProvider<List<Product>>((ref) {
  return [
    // Fruits
    Product(
      id: '1',
      name: 'Red Apples',
      description: 'Fresh, crisp red apples',
      price: 250.0,
      category: 'fruits',
      imageUrl: 'https://images.unsplash.com/photo-1560806674-d257cac4c5b8?q=80&w=400&auto=format&fit=crop',
      stock: 50,
      unit: '1 kg',
      brand: 'Local',
      rating: 4.8,
      reviewCount: 120,
    ),
    Product(
      id: '2',
      name: 'Bananas',
      description: 'Sweet, ripe bananas',
      price: 120.0,
      category: 'fruits',
      imageUrl: 'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?q=80&w=400&auto=format&fit=crop',
      stock: 60,
      unit: '1 kg',
      brand: 'Local',
      rating: 4.7,
      reviewCount: 95,
    ),
    // Vegetables
    Product(
      id: '3',
      name: 'Organic Carrots',
      description: 'Freshly harvested organic carrots',
      price: 150.0,
      category: 'vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=400&auto=format&fit=crop',
      stock: 45,
      unit: '500g',
      brand: 'EcoFarm',
      rating: 4.7,
      reviewCount: 64,
    ),
    // Dairy
    Product(
      id: '4',
      name: 'Anchor Full Cream Milk',
      description: 'Full cream fresh milk',
      price: 280.0,
      category: 'dairy',
      imageUrl: 'https://images.unsplash.com/photo-1553531088-df340e76baaf?q=80&w=400&auto=format&fit=crop',
      stock: 40,
      unit: '1 L',
      brand: 'Anchor',
      rating: 4.8,
      reviewCount: 200,
    ),
    // Snacks
    Product(
      id: '5',
      name: 'Lay\'s Chips',
      description: 'Crispy potato chips',
      price: 180.0,
      category: 'snacks',
      imageUrl: 'https://images.unsplash.com/photo-1584431267534-578f4ee4fdf4?q=80&w=400&auto=format&fit=crop',
      stock: 100,
      unit: '50g',
      brand: 'Lay\'s',
      rating: 4.5,
      reviewCount: 150,
      isOnSale: true,
      discount: 15,
            ),
          ];
        });

// Categories provider
final categoriesProvider = StateProvider<List<String>>((ref) {
  return ['fruits', 'vegetables', 'dairy', 'snacks', 'groceries'];
});

// Promotions provider
final promotionsProvider = StateProvider<List<String>>((ref) {
  return ['promotion1', 'promotion2', 'promotion3'];
});
