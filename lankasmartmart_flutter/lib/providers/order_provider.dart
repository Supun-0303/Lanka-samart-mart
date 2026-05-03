import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_models.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>(
  (ref) => OrderNotifier(),
);

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  void addOrder(Order order) {
    state = [...state, order];
  }

  void updateOrder(String orderId, Order updatedOrder) {
    state = state.map((order) {
      if (order.id == orderId) {
        return updatedOrder;
      }
      return order;
    }).toList();
  }

  void cancelOrder(String orderId) {
    final order = state.firstWhere((o) => o.id == orderId);
    final cancelledOrder = Order(
      id: order.id,
      userId: order.userId,
      items: order.items,
      totalAmount: order.totalAmount,
      deliveryAddress: order.deliveryAddress,
      paymentMethod: order.paymentMethod,
      status: 'cancelled',
      createdAt: order.createdAt,
    );
    updateOrder(orderId, cancelledOrder);
  }

  void clearOrders() {
    state = [];
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, Map<String, List<Order>>>(
      (ref) => OrdersNotifier(),
    );

class OrdersNotifier extends StateNotifier<Map<String, List<Order>>> {
  OrdersNotifier() : super({});

  void setOrders(String userId, List<Order> orders) {
    state = {...state, userId: orders};
  }

  List<Order> getOrdersByUserId(String userId) => state[userId] ?? [];

  Order? getOrderById(String orderId) {
    for (final orders in state.values) {
      final order = orders.cast<Order?>().firstWhere(
        (o) => o?.id == orderId,
        orElse: () => null,
      );
      if (order != null) return order;
    }
    return null;
  }
}
