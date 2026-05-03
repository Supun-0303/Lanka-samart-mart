import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_models.dart';

final addressProvider = StateNotifierProvider<AddressNotifier, List<Address>>(
  (ref) => AddressNotifier(),
);

class AddressNotifier extends StateNotifier<List<Address>> {
  AddressNotifier() : super([]);

  void addAddress(Address address) {
    // If this is marked as default, unset other defaults
    if (address.isDefault) {
      state = state.map((addr) => addr.copyWith(isDefault: false)).toList();
    }
    state = [...state, address];
  }

  void updateAddress(String addressId, Address updatedAddress) {
    if (updatedAddress.isDefault) {
      state = state.map((addr) => addr.copyWith(isDefault: false)).toList();
    }
    state = state.map((addr) {
      if (addr.id == addressId) {
        return updatedAddress;
      }
      return addr;
    }).toList();
  }

  void deleteAddress(String addressId) {
    state = state.where((addr) => addr.id != addressId).toList();
  }

  void setDefaultAddress(String addressId) {
    state = state.map((addr) {
      if (addr.id == addressId) {
        return addr.copyWith(isDefault: true);
      }
      return addr.copyWith(isDefault: false);
    }).toList();
  }

  Address? getDefaultAddress() {
    try {
      return state.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return null;
    }
  }

  void clearAddresses() {
    state = [];
  }
}

final paymentCardProvider =
    StateNotifierProvider<PaymentCardNotifier, List<PaymentCard>>(
      (ref) => PaymentCardNotifier(),
    );

class PaymentCardNotifier extends StateNotifier<List<PaymentCard>> {
  PaymentCardNotifier() : super([]);

  void addCard(PaymentCard card) {
    if (card.isDefault) {
      state = state.map((c) => c.copyWith(isDefault: false)).toList();
    }
    state = [...state, card];
  }

  void updateCard(String cardId, PaymentCard updatedCard) {
    if (updatedCard.isDefault) {
      state = state.map((c) => c.copyWith(isDefault: false)).toList();
    }
    state = state.map((card) {
      if (card.id == cardId) {
        return updatedCard;
      }
      return card;
    }).toList();
  }

  void deleteCard(String cardId) {
    state = state.where((card) => card.id != cardId).toList();
  }

  void setDefaultCard(String cardId) {
    state = state.map((card) {
      if (card.id == cardId) {
        return card.copyWith(isDefault: true);
      }
      return card.copyWith(isDefault: false);
    }).toList();
  }

  PaymentCard? getDefaultCard() {
    try {
      return state.firstWhere((card) => card.isDefault);
    } catch (e) {
      return null;
    }
  }

  void clearCards() {
    state = [];
  }
}

extension PaymentCardCopyWith on PaymentCard {
  PaymentCard copyWith({
    String? id,
    String? userId,
    String? last4Digits,
    String? cardHolder,
    String? cardType,
    String? expiryMonth,
    String? expiryYear,
    bool? isDefault,
    DateTime? createdAt,
  }) => PaymentCard(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    last4Digits: last4Digits ?? this.last4Digits,
    cardHolder: cardHolder ?? this.cardHolder,
    cardType: cardType ?? this.cardType,
    expiryMonth: expiryMonth ?? this.expiryMonth,
    expiryYear: expiryYear ?? this.expiryYear,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
}
