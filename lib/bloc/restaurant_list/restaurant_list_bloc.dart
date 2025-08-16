import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/restaurant_repository.dart';
import 'restaurant_list_event.dart';
import 'restaurant_list_state.dart';

class RestaurantListBloc
    extends Bloc<RestaurantListEvent, RestaurantListState> {
  final RestaurantRepository _restaurantRepository;

  RestaurantListBloc(this._restaurantRepository)
    : super(RestaurantListInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<SearchRestaurants>(_onSearchRestaurants);
    on<FilterRestaurants>(_onFilterRestaurants);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantListState> emit,
  ) async {
    emit(RestaurantListLoading());
    try {
      final restaurants = await _restaurantRepository.getRestaurants();
      emit(RestaurantListLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantListError(message: e.toString()));
    }
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurants event,
    Emitter<RestaurantListState> emit,
  ) async {
    emit(RestaurantListLoading());
    try {
      final restaurants = await _restaurantRepository.searchRestaurants(
        event.query,
      );
      emit(RestaurantListLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantListError(message: e.toString()));
    }
  }

  Future<void> _onFilterRestaurants(
    FilterRestaurants event,
    Emitter<RestaurantListState> emit,
  ) async {
    emit(RestaurantListLoading());
    try {
      final restaurants = await _restaurantRepository.filterRestaurants(
        event.filter,
      );
      emit(RestaurantListLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantListError(message: e.toString()));
    }
  }
}
