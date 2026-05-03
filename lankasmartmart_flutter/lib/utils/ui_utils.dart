import 'package:flutter/material.dart';

class MockDataStore {
  static final List<String> mockAddresses = [
    "123 Main St, Colombo 7, Colombo",
    "456 Galle Rd, Mount Lavinia",
    "789 Kandy Rd, Dehiwala",
  ];

  static final List<String> mockPaymentMethods = [
    "Visa ending in 4242",
    "Mastercard ending in 5555",
  ];

  static final List<Map<String, String>> mockOrders = [
    {
      'id': '001',
      'status': 'Delivered',
      'total': 'Rs. 2,450.00',
      'date': '2024-01-15',
    },
    {
      'id': '002',
      'status': 'In Transit',
      'total': 'Rs. 1,890.00',
      'date': '2024-01-20',
    },
  ];
}

class UiUtils {
  static String formatPrice(double price) {
    return 'Rs. ${price.toStringAsFixed(2)}';
  }

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
