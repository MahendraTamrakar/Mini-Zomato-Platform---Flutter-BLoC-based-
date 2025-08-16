import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

class CartItem extends Equatable {
  final MenuItemModel menuItem;
  final int quantity;
  final String? customizations;

  const CartItem({
    required this.menuItem,
    required this.quantity,
    this.customizations,
  });

  double get totalPrice => menuItem.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItem: MenuItemModel.fromJson(json['menuItem']),
      quantity: json['quantity'],
      customizations: json['customizations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
      'customizations': customizations,
    };
  }

  CartItem copyWith({
    MenuItemModel? menuItem,
    int? quantity,
    String? customizations,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
    );
  }

  @override
  List<Object?> get props => [menuItem, quantity, customizations];
}
