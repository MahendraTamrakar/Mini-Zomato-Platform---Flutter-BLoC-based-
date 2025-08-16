import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderPlacing());
    try {
      final order = await _orderRepository.placeOrder(
        event.items,
        event.deliveryAddress,
      );
      emit(OrderPlaced(order: order));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}
