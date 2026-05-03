import '../utils/id_generator.dart';

class Category {
  Category({
    String? id,
    required this.name,
    required this.icon,
    this.description = '',
    required this.imageUrl,
  }) : id = id ?? generateId();

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
  final String id;
  final String name;
  final String icon;
  final String description;
  final String imageUrl;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'description': description,
    'imageUrl': imageUrl,
  };
}

class Product {
  Product({
    String? id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice = 0.0,
    required this.category,
    required this.imageUrl,
    required this.stock,
    required this.unit,
    required this.brand,
    this.isOnSale = false,
    this.discount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.reviews = const [],
  }) : id = id ?? generateId();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      stock: json['stock'] ?? 0,
      unit: json['unit'] ?? '',
      brand: json['brand'] ?? '',
      isOnSale: json['isOnSale'] ?? false,
      discount: json['discount'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String category;
  final String imageUrl;
  final int stock;
  final String unit;
  final String brand;
  final bool isOnSale;
  final int discount;
  final double rating;
  final int reviewCount;
  final List<Review> reviews;

  double get discountedPrice {
    if (isOnSale && discount > 0) {
      return price * (100 - discount) / 100.0;
    }
    return price;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'originalPrice': originalPrice,
    'category': category,
    'imageUrl': imageUrl,
    'stock': stock,
    'unit': unit,
    'brand': brand,
    'isOnSale': isOnSale,
    'discount': discount,
    'rating': rating,
    'reviewCount': reviewCount,
    'reviews': reviews.map((r) => r.toJson()).toList(),
  };
}

class Review {
  Review({
    String? id,
    required this.userId,
    required this.userName,
    this.rating = 5,
    required this.comment,
    DateTime? timestamp,
  }) : id = id ?? generateId(),
       timestamp = timestamp ?? DateTime.now();

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
          : DateTime.now(),
    );
  }
  final String id;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };
}

class CartItem {
  CartItem({required this.productId, required this.product, this.quantity = 1});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
    );
  }
  final String productId;
  final Product product;
  int quantity;

  double get totalPrice => product.discountedPrice * quantity;

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'product': product.toJson(),
    'quantity': quantity,
  };
}

class Promotion {
  Promotion({
    String? id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.backgroundColor = '#53B175',
    this.actionType = 'product',
    this.actionId = '',
  }) : id = id ?? generateId();

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      backgroundColor: json['backgroundColor'] ?? '#53B175',
      actionType: json['actionType'] ?? 'product',
      actionId: json['actionId'] ?? '',
    );
  }
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String backgroundColor;
  final String actionType;
  final String actionId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'imageUrl': imageUrl,
    'backgroundColor': backgroundColor,
    'actionType': actionType,
    'actionId': actionId,
  };
}
