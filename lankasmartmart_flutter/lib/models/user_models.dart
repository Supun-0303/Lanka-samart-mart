import '../utils/id_generator.dart';

class Address {
  Address({
    String? id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.postalCode,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.isDefault = false,
    DateTime? createdAt,
  }) : id = id ?? generateId(),
       createdAt = createdAt ?? DateTime.now();

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : DateTime.now(),
    );
  }
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'phone': phone,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'city': city,
    'postalCode': postalCode,
    'latitude': latitude,
    'longitude': longitude,
    'isDefault': isDefault,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  Address copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
    double? latitude,
    double? longitude,
    bool? isDefault,
    DateTime? createdAt,
  }) => Address(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    addressLine1: addressLine1 ?? this.addressLine1,
    addressLine2: addressLine2 ?? this.addressLine2,
    city: city ?? this.city,
    postalCode: postalCode ?? this.postalCode,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
}

class PaymentCard {
  PaymentCard({
    String? id,
    required this.userId,
    required this.last4Digits,
    required this.cardHolder,
    required this.cardType,
    required this.expiryMonth,
    required this.expiryYear,
    this.isDefault = false,
    DateTime? createdAt,
  }) : id = id ?? generateId(),
       createdAt = createdAt ?? DateTime.now();

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      last4Digits: json['last4Digits'] ?? '',
      cardHolder: json['cardHolder'] ?? '',
      cardType: json['cardType'] ?? '',
      expiryMonth: json['expiryMonth'] ?? '',
      expiryYear: json['expiryYear'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : DateTime.now(),
    );
  }
  final String id;
  final String userId;
  final String last4Digits;
  final String cardHolder;
  final String cardType;
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'last4Digits': last4Digits,
    'cardHolder': cardHolder,
    'cardType': cardType,
    'expiryMonth': expiryMonth,
    'expiryYear': expiryYear,
    'isDefault': isDefault,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };
}

class ScannedCardData {
  ScannedCardData({
    this.cardNumber = '',
    this.cardHolder = '',
    this.expiryMonth = '',
    this.expiryYear = '',
    this.cvv = '',
  });
  final String cardNumber;
  final String cardHolder;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
}
