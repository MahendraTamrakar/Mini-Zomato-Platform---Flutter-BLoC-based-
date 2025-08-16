import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/order_repository.dart';
import 'order_history_event.dart';
import 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderRepository _orderRepository;

  OrderHistoryBloc(this._orderRepository) : super(OrderHistoryInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
  }

  Future<void> _onLoadOrderHistory(
    LoadOrderHistory event,
    Emitter<OrderHistoryState> emit,
  ) async {
    emit(OrderHistoryLoading());
    try {
      final orders = await _orderRepository.getOrderHistory();
      emit(OrderHistoryLoaded(orders: orders));
    } catch (e) {
      emit(OrderHistoryError(message: e.toString()));
    }
  }
}
