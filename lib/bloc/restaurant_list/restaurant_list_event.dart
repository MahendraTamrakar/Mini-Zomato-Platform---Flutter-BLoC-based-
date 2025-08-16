abstract class RestaurantListEvent {}

class LoadRestaurants extends RestaurantListEvent {}

class SearchRestaurants extends RestaurantListEvent {
  final String query;

  SearchRestaurants({required this.query});
}

class FilterRestaurants extends RestaurantListEvent {
  final String filter;

  FilterRestaurants({required this.filter});
}
