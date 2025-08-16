import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.addToCart(event.menuItem, event.quantity);
      final cartData = await _cartRepository.getCartItems();
      emit(
        CartLoaded(items: cartData['items'], subtotal: cartData['subtotal']),
      );
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.removeFromCart(event.menuItemId);
      final cartData = await _cartRepository.getCartItems();
      emit(
        CartLoaded(items: cartData['items'], subtotal: cartData['subtotal']),
      );
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.updateQuantity(event.menuItemId, event.quantity);
      final cartData = await _cartRepository.getCartItems();
      emit(
        CartLoaded(items: cartData['items'], subtotal: cartData['subtotal']),
      );
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepository.clearCart();
      emit(CartLoaded(items: [], subtotal: 0.0));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cartData = await _cartRepository.getCartItems();
      emit(
        CartLoaded(items: cartData['items'], subtotal: cartData['subtotal']),
      );
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
