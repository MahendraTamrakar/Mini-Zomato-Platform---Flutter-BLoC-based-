import 'package:mini_zomato_platform/models/menu_item_model.dart';

import '../../models/cart_item.dart';

class CartRepository {
  List<CartItem> _cartItems = [];

  Future<void> addToCart(MenuItemModel menuItem, int quantity) async {
    await Future.delayed(Duration(milliseconds: 500));

    final existingIndex = _cartItems.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      _cartItems.add(CartItem(menuItem: menuItem, quantity: quantity));
    }
  }

  Future<void> removeFromCart(String menuItemId) async {
    await Future.delayed(Duration(milliseconds: 500));
    _cartItems.removeWhere((item) => item.menuItem.id == menuItemId);
  }

  Future<void> updateQuantity(String menuItemId, int quantity) async {
    await Future.delayed(Duration(milliseconds: 500));

    final index = _cartItems.indexWhere(
      (item) => item.menuItem.id == menuItemId,
    );
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
    }
  }

  Future<void> clearCart() async {
    await Future.delayed(Duration(milliseconds: 500));
    _cartItems.clear();
  }

  Future<Map<String, dynamic>> getCartItems() async {
    await Future.delayed(Duration(milliseconds: 300));

    final subtotal = _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

    return {'items': List<CartItem>.from(_cartItems), 'subtotal': subtotal};
  }
}
