import 'package:mini_zomato_platform/models/menu_item_model.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final MenuItemModel menuItem;
  final int quantity;

  AddToCart({required this.menuItem, required this.quantity});
}

class RemoveFromCart extends CartEvent {
  final String menuItemId;

  RemoveFromCart({required this.menuItemId});
}

class UpdateCartItemQuantity extends CartEvent {
  final String menuItemId;
  final int quantity;

  UpdateCartItemQuantity({required this.menuItemId, required this.quantity});
}

class ClearCart extends CartEvent {}

class LoadCart extends CartEvent {}
