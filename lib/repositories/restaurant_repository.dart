import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mini_zomato_platform/models/restaurant_model.dart';
import '../core/utils/enums_utils.dart';

class RestaurantRepository {
  List<RestaurantModel>? _mockRestaurants;

  // Load mock restaurants from JSON file
  Future<List<RestaurantModel>> _loadMockRestaurants() async {
    if (_mockRestaurants != null) return _mockRestaurants!;

    try {
      final String jsonString = await rootBundle.loadString(
        'lib/data/MOCK_DATA_RESTAURANT.json',
      );
      final List<dynamic> restaurantsJson = json.decode(jsonString);

      _mockRestaurants =
          restaurantsJson
              .map((restaurantJson) => RestaurantModel.fromJson(restaurantJson))
              .toList();

      return _mockRestaurants!;
    } catch (e) {
      throw Exception("Failed to load restaurant mock data: $e");
    }
  }

  Future<List<RestaurantModel>> getRestaurants() async {
    await Future.delayed(Duration(seconds: 1));
    return await _loadMockRestaurants();
  }

  Future<RestaurantModel?> getRestaurantById(String id) async {
    await Future.delayed(Duration(seconds: 1));
    final restaurants = await _loadMockRestaurants();

    try {
      return restaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      return null; // Restaurant not found
    }
  }

  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    if (query.isEmpty) return allRestaurants;

    return allRestaurants
        .where(
          (restaurant) =>
              restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
              restaurant.cuisines.any(
                (cuisine) =>
                    cuisine.toLowerCase().contains(query.toLowerCase()),
              ) ||
              restaurant.location.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Future<List<RestaurantModel>> filterRestaurants(String filter) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    switch (filter.toLowerCase()) {
      case "open":
        return allRestaurants
            .where((r) => r.status == RestaurantStatus.open)
            .toList();
      case "closed":
        return allRestaurants
            .where((r) => r.status == RestaurantStatus.closed)
            .toList();
      case "temporarily_closed":
        return allRestaurants
            .where((r) => r.status == RestaurantStatus.temporarilyClosed)
            .toList();
      case "coming_soon":
        return allRestaurants
            .where((r) => r.status == RestaurantStatus.comingSoon)
            .toList();
      case "rating":
        return allRestaurants.where((r) => r.rating >= 4.5).toList();
      case "high_rating":
        return allRestaurants.where((r) => r.rating >= 4.0).toList();
      case "vegetarian":
        return allRestaurants
            .where((r) => r.vegNonVeg == VegNonVeg.veg)
            .toList();
      case "non_vegetarian":
        return allRestaurants
            .where((r) => r.vegNonVeg == VegNonVeg.nonVeg)
            .toList();
      case "both":
        return allRestaurants
            .where((r) => r.vegNonVeg == VegNonVeg.both)
            .toList();
      // Restaurant Types
      case "fine_dining":
        return allRestaurants
            .where((r) => r.type == RestaurantType.fineDining)
            .toList();
      case "casual_dining":
        return allRestaurants
            .where((r) => r.type == RestaurantType.casualDining)
            .toList();
      case "quick_service":
        return allRestaurants
            .where((r) => r.type == RestaurantType.quickService)
            .toList();
      case "fast_casual":
        return allRestaurants
            .where((r) => r.type == RestaurantType.fastCasual)
            .toList();
      case "cafe":
        return allRestaurants
            .where((r) => r.type == RestaurantType.cafe)
            .toList();
      case "cloud_kitchen":
        return allRestaurants
            .where((r) => r.type == RestaurantType.cloudKitchen)
            .toList();
      case "bakery":
        return allRestaurants
            .where((r) => r.type == RestaurantType.bakery)
            .toList();
      case "bar":
        return allRestaurants
            .where((r) => r.type == RestaurantType.bar)
            .toList();
      case "food_truck":
        return allRestaurants
            .where((r) => r.type == RestaurantType.foodTruck)
            .toList();
      case "street_food":
        return allRestaurants
            .where((r) => r.type == RestaurantType.streetFood)
            .toList();
      default:
        return allRestaurants;
    }
  }

  Future<List<RestaurantModel>> getRestaurantsByCuisine(String cuisine) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where(
          (restaurant) => restaurant.cuisines.any(
            (c) => c.toLowerCase() == cuisine.toLowerCase(),
          ),
        )
        .toList();
  }

  Future<List<RestaurantModel>> getRestaurantsByType(
    RestaurantType type,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where((restaurant) => restaurant.type == type)
        .toList();
  }

  Future<List<RestaurantModel>> getRestaurantsByVegType(
    VegNonVeg vegType,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where((restaurant) => restaurant.vegNonVeg == vegType)
        .toList();
  }

  Future<List<RestaurantModel>> getNearbyRestaurants(
    double latitude,
    double longitude, {
    double radiusKm = 10.0,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    // For mock data, return all restaurants since we don't have actual coordinates
    // In a real app, you'd calculate distance based on lat/lng
    return allRestaurants;
  }

  Future<List<RestaurantModel>> getFeaturedRestaurants() async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where((restaurant) => restaurant.rating >= 4.3)
        .take(10)
        .toList();
  }

  Future<List<RestaurantModel>> getTopRatedRestaurants({int limit = 20}) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    // Sort by rating in descending order
    final sortedRestaurants = List<RestaurantModel>.from(allRestaurants);
    sortedRestaurants.sort((a, b) => b.rating.compareTo(a.rating));

    return sortedRestaurants.take(limit).toList();
  }

  Future<List<RestaurantModel>> getOpenRestaurants() async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where((restaurant) => restaurant.status == RestaurantStatus.open)
        .toList();
  }

  Future<List<RestaurantModel>> getClosedRestaurants() async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where(
          (restaurant) =>
              restaurant.status == RestaurantStatus.closed ||
              restaurant.status == RestaurantStatus.temporarilyClosed,
        )
        .toList();
  }

  Future<List<RestaurantModel>> getComingSoonRestaurants() async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where((restaurant) => restaurant.status == RestaurantStatus.comingSoon)
        .toList();
  }

  Future<List<RestaurantModel>> getCurrentlyOpenRestaurants() async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where(
          (restaurant) =>
              restaurant.status == RestaurantStatus.open &&
              restaurant.openingHours.isOpenNow(),
        )
        .toList();
  }

  Future<List<RestaurantModel>> getRestaurantsByRating(double minRating) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where((restaurant) => restaurant.rating >= minRating)
        .toList();
  }

  // Helper method to reset mock data cache
  void resetMockData() {
    _mockRestaurants = null;
  }

  // Helper method to get all unique cuisines
  Future<List<String>> getAllCuisines() async {
    final restaurants = await getRestaurants();
    final Set<String> cuisines = {};

    for (var restaurant in restaurants) {
      cuisines.addAll(restaurant.cuisines);
    }

    return cuisines.toList()..sort();
  }

  // Helper method to get all unique restaurant types
  Future<List<RestaurantType>> getAllTypes() async {
    final restaurants = await getRestaurants();
    final Set<RestaurantType> types = {};

    for (var restaurant in restaurants) {
      types.add(restaurant.type);
    }

    return types.toList();
  }

  // Get restaurants by location/area
  Future<List<RestaurantModel>> getRestaurantsByLocation(
    String location,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final allRestaurants = await getRestaurants();

    return allRestaurants
        .where(
          (restaurant) => restaurant.location.toLowerCase().contains(
            location.toLowerCase(),
          ),
        )
        .toList();
  }

  // Get restaurant statistics
  Future<Map<String, dynamic>> getRestaurantStats() async {
    final restaurants = await getRestaurants();

    final stats = <String, dynamic>{
      'totalRestaurants': restaurants.length,
      'openRestaurants':
          restaurants.where((r) => r.status == RestaurantStatus.open).length,
      'closedRestaurants':
          restaurants.where((r) => r.status == RestaurantStatus.closed).length,
      'temporarilyClosedRestaurants':
          restaurants
              .where((r) => r.status == RestaurantStatus.temporarilyClosed)
              .length,
      'comingSoonRestaurants':
          restaurants
              .where((r) => r.status == RestaurantStatus.comingSoon)
              .length,
      'averageRating':
          restaurants.isEmpty
              ? 0.0
              : restaurants.map((r) => r.rating).reduce((a, b) => a + b) /
                  restaurants.length,
      'vegRestaurants':
          restaurants.where((r) => r.vegNonVeg == VegNonVeg.veg).length,
      'nonVegRestaurants':
          restaurants.where((r) => r.vegNonVeg == VegNonVeg.nonVeg).length,
      'bothRestaurants':
          restaurants.where((r) => r.vegNonVeg == VegNonVeg.both).length,
      'currentlyOpen':
          restaurants
              .where(
                (r) =>
                    r.status == RestaurantStatus.open &&
                    r.openingHours.isOpenNow(),
              )
              .length,
      // Restaurant type breakdown
      'fineDining':
          restaurants.where((r) => r.type == RestaurantType.fineDining).length,
      'casualDining':
          restaurants
              .where((r) => r.type == RestaurantType.casualDining)
              .length,
      'quickService':
          restaurants
              .where((r) => r.type == RestaurantType.quickService)
              .length,
      'fastCasual':
          restaurants.where((r) => r.type == RestaurantType.fastCasual).length,
      'cafe': restaurants.where((r) => r.type == RestaurantType.cafe).length,
      'cloudKitchen':
          restaurants
              .where((r) => r.type == RestaurantType.cloudKitchen)
              .length,
      'bakery':
          restaurants.where((r) => r.type == RestaurantType.bakery).length,
      'bar': restaurants.where((r) => r.type == RestaurantType.bar).length,
      'foodTruck':
          restaurants.where((r) => r.type == RestaurantType.foodTruck).length,
      'streetFood':
          restaurants.where((r) => r.type == RestaurantType.streetFood).length,
    };

    return stats;
  }
}
