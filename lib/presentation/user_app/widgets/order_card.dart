import 'package:flutter/material.dart';
import 'package:mini_zomato_platform/models/menu_item_model.dart';
import '../../../core/utils/enums_utils.dart';
import '../../../models/cart_item.dart';
import '../../../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id.substring(order.id.length - 6)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              order.restaurantName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Ordered on ${_formatDateTime(order.orderTime)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Paid',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '₹${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showOrderDetails(context),
                    child: Text('View Details'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        order.status == OrderStatus.delivered
                            ? () => _reorder(context)
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      order.status == OrderStatus.delivered
                          ? 'Reorder'
                          : 'Track Order',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.confirmed:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.outForDelivery:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showOrderDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Order Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Restaurant: ${order.restaurantName}'),
                SizedBox(height: 8),
                Text('Delivery Address: ${order.deliveryAddress}'),
                SizedBox(height: 8),
                Text('Items:'),
                ...order.items
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.only(left: 16, top: 4),
                        child: Text(
                          '• ${item.menuItem.name} x${item.quantity}',
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _reorder(BuildContext context) {
    // Navigate to restaurant page or add items to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reorder functionality will be implemented')),
    );
  }
}

// Additional missing extension for CartItem.fromJson
extension CartItemExtension on CartItem {
  static CartItem fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItem: MenuItemModel.fromJson(json['menuItem']),
      quantity: json['quantity'],
      customizations: json['customizations'],
    );
  }
}
