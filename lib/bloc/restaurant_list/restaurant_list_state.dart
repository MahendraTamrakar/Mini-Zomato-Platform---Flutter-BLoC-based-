import 'package:mini_zomato_platform/models/restaurant_model.dart';

import '';

abstract class RestaurantListState {}

class RestaurantListInitial extends RestaurantListState {}

class RestaurantListLoading extends RestaurantListState {}

class RestaurantListLoaded extends RestaurantListState {
  final List<RestaurantModel> restaurants;

  RestaurantListLoaded({required this.restaurants});
}

class RestaurantListError extends RestaurantListState {
  final String message;

  RestaurantListError({required this.message});
}
