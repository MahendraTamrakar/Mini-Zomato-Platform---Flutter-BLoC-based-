import 'package:equatable/equatable.dart ';
import '../core/utils/enums_utils.dart';
import 'cart_item.dart';

class Order extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final DateTime orderTime;
  final String deliveryAddress;

  const Order({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.orderTime,
    required this.deliveryAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      items:
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      total: json['total'].toDouble(),
      status: OrderStatus.values.byName(json['status']),
      orderTime: DateTime.parse(json['orderTime']),
      deliveryAddress: json['deliveryAddress'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    restaurantName,
    items,
    subtotal,
    deliveryFee,
    total,
    status,
    orderTime,
    deliveryAddress,
  ];
}
