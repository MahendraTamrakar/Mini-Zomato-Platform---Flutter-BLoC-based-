import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/order.dart';
import '../../models/cart_item.dart';
import '../../models/restaurant_model.dart';
import '../core/utils/enums_utils.dart';

class OrderRepository {
  final List<Order> _orders = [];
  List<RestaurantModel>? _cachedRestaurants;

  Future<List<RestaurantModel>> _loadRestaurantsFromJson() async {
    if (_cachedRestaurants != null) {
      return _cachedRestaurants!;
    }

    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(
        'lib/data/MOCK_DATA_RESTAURANT.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      // Convert JSON to RestaurantModel list
      _cachedRestaurants =
          jsonList.map((json) => RestaurantModel.fromJson(json)).toList();

      return _cachedRestaurants!;
    } catch (e) {
      print('Error loading restaurants from JSON: $e');
      return [];
    }
  }

  Future<String> _getRestaurantName(String restaurantId) async {
    try {
      final restaurants = await _loadRestaurantsFromJson();
      final restaurant = restaurants.firstWhere(
        (restaurant) => restaurant.id == restaurantId,
        orElse: () => throw Exception('Restaurant not found'),
      );
      return restaurant.name;
    } catch (e) {
      print('Error getting restaurant name: $e');
      return "Unknown Restaurant"; // Fallback name
    }
  }

  Future<Order> placeOrder(List<CartItem> items, String deliveryAddress) async {
    await Future.delayed(Duration(seconds: 2));

    if (items.isEmpty) {
      throw Exception('Cannot place order with empty cart');
    }

    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = 50.0;
    final total = subtotal + deliveryFee;

    // Get restaurant name from mock data
    final restaurantId = items.first.menuItem.restaurantId;
    final restaurantName = await _getRestaurantName(restaurantId);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      items: List<CartItem>.from(items),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      status: OrderStatus.placed,
      orderTime: DateTime.now(),
      deliveryAddress: deliveryAddress,
    );

    _orders.insert(0, order);
    return order;
  }

  Future<List<Order>> getOrderHistory() async {
    await Future.delayed(Duration(seconds: 1));
    return List<Order>.from(_orders);
  }

  // Additional methods for order management

  Future<Order?> getOrderById(String orderId) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    await Future.delayed(Duration(seconds: 1));
    return _orders.where((order) => order.status == status).toList();
  }

  Future<List<Order>> getOrdersByRestaurant(String restaurantId) async {
    await Future.delayed(Duration(seconds: 1));
    return _orders
        .where((order) => order.restaurantId == restaurantId)
        .toList();
  }

  Future<Order> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await Future.delayed(Duration(seconds: 1));

    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) {
      throw Exception('Order not found');
    }

    // Create updated order with new status
    final currentOrder = _orders[orderIndex];
    final updatedOrder = Order(
      id: currentOrder.id,
      restaurantId: currentOrder.restaurantId,
      restaurantName: currentOrder.restaurantName,
      items: currentOrder.items,
      subtotal: currentOrder.subtotal,
      deliveryFee: currentOrder.deliveryFee,
      total: currentOrder.total,
      status: newStatus,
      orderTime: currentOrder.orderTime,
      deliveryAddress: currentOrder.deliveryAddress,
    );

    _orders[orderIndex] = updatedOrder;
    return updatedOrder;
  }

  Future<bool> cancelOrder(String orderId) async {
    await Future.delayed(Duration(seconds: 1));

    final order = _orders.where((order) => order.id == orderId).firstOrNull;
    if (order == null) {
      return false;
    }

    // Only allow cancellation if order is in certain statuses
    if (order.status == OrderStatus.placed ||
        order.status == OrderStatus.preparing) {
      await updateOrderStatus(orderId, OrderStatus.cancelled);
      return true;
    }

    return false;
  }

  // Method to simulate order status updates (for testing)
  Future<void> simulateOrderProgress(String orderId) async {
    final statuses = [
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    for (final status in statuses) {
      await Future.delayed(Duration(seconds: 3));
      await updateOrderStatus(orderId, status);
    }
  }

  // Calculate order statistics
  Future<Map<String, dynamic>> getOrderStatistics() async {
    if (_orders.isEmpty) {
      return {
        'totalOrders': 0,
        'totalSpent': 0.0,
        'averageOrderValue': 0.0,
        'favoriteRestaurant': null,
      };
    }

    final totalOrders = _orders.length;
    final totalSpent = _orders.fold(0.0, (sum, order) => sum + order.total);
    final averageOrderValue = totalSpent / totalOrders;

    // Find favorite restaurant (most ordered from)
    final restaurantOrderCounts = <String, int>{};
    for (final order in _orders) {
      restaurantOrderCounts[order.restaurantId] =
          (restaurantOrderCounts[order.restaurantId] ?? 0) + 1;
    }

    String? favoriteRestaurantId;
    int maxOrders = 0;
    restaurantOrderCounts.forEach((restaurantId, count) {
      if (count > maxOrders) {
        maxOrders = count;
        favoriteRestaurantId = restaurantId;
      }
    });

    String? favoriteRestaurantName;
    if (favoriteRestaurantId != null) {
      favoriteRestaurantName = await _getRestaurantName(favoriteRestaurantId!);
    }

    return {
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'averageOrderValue': averageOrderValue,
      'favoriteRestaurant': favoriteRestaurantName,
    };
  }

  // Clear cache and orders (useful for testing)
  void clearCache() {
    _cachedRestaurants = null;
  }

  void clearOrders() {
    _orders.clear();
  }
}
