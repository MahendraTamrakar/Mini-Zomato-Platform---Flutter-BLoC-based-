import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/menu_item_model.dart';
import '../../core/utils/enums_utils.dart';

class MenuRepository {
  List<MenuItemModel>? _cachedMenuItems;

  Future<List<MenuItemModel>> _loadMenuItemsFromJson() async {
    if (_cachedMenuItems != null) {
      return _cachedMenuItems!;
    }

    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(
        'lib/data/MOCK_MENU_ITEMS.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      // Convert JSON to MenuItemModel list with validation
      _cachedMenuItems =
          jsonList
              .map((json) {
                try {
                  return MenuItemModel.fromJson(json);
                } catch (e) {
                  print('Error parsing menu item: $json, Error: $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<MenuItemModel>()
              .toList();

      print('Loaded ${_cachedMenuItems!.length} menu items from JSON');
      return _cachedMenuItems!;
    } catch (e) {
      print('Error loading menu items from JSON: $e');
      return [];
    }
  }

  Future<List<MenuItemModel>> getMenuItems(String restaurantId) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    final allMenuItems = await _loadMenuItemsFromJson();

    // Filter menu items by restaurant ID
    final filteredItems =
        allMenuItems
            .where((item) => item.restaurantId == restaurantId)
            .toList();

    print('Found ${filteredItems.length} items for restaurant $restaurantId');
    return filteredItems;
  }

  // Get all menu items (regardless of restaurant)
  Future<List<MenuItemModel>> getAllMenuItems() async {
    return await _loadMenuItemsFromJson();
  }

  // Get menu items grouped by category for a restaurant
  Future<Map<MenuCategory, List<MenuItemModel>>> getMenuItemsGroupedByCategory(
    String restaurantId,
  ) async {
    final allItems = await getMenuItems(restaurantId);
    Map<MenuCategory, List<MenuItemModel>> groupedItems = {};

    for (final item in allItems) {
      if (groupedItems[item.category] == null) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category]!.add(item);
    }

    return groupedItems;
  }

  // Additional method to get menu items by category
  Future<List<MenuItemModel>> getMenuItemsByCategory(
    String restaurantId,
    MenuCategory category,
  ) async {
    final allItems = await getMenuItems(restaurantId);
    return allItems.where((item) => item.category == category).toList();
  }

  // Method to get only available menu items
  Future<List<MenuItemModel>> getAvailableMenuItems(String restaurantId) async {
    final allItems = await getMenuItems(restaurantId);
    return allItems.where((item) => item.isAvailable).toList();
  }

  // Method to get vegetarian menu items
  Future<List<MenuItemModel>> getVegetarianMenuItems(
    String restaurantId,
  ) async {
    final allItems = await getMenuItems(restaurantId);
    return allItems.where((item) => item.isVegetarian).toList();
  }

  // Method to get non-vegetarian menu items
  Future<List<MenuItemModel>> getNonVegetarianMenuItems(
    String restaurantId,
  ) async {
    final allItems = await getMenuItems(restaurantId);
    return allItems.where((item) => !item.isVegetarian).toList();
  }

  // Method to search menu items by name
  Future<List<MenuItemModel>> searchMenuItems(
    String restaurantId,
    String searchQuery,
  ) async {
    if (searchQuery.isEmpty) return [];

    final allItems = await getMenuItems(restaurantId);
    final query = searchQuery.toLowerCase().trim();

    return allItems
        .where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query) ||
              item.category.name.toLowerCase().contains(query),
        )
        .toList();
  }

  // Method to get menu item by ID
  Future<MenuItemModel?> getMenuItemById(String itemId) async {
    final allItems = await _loadMenuItemsFromJson();
    try {
      return allItems.firstWhere((item) => item.id == itemId);
    } catch (e) {
      print('Menu item with ID $itemId not found');
      return null;
    }
  }

  // Method to get menu items by multiple restaurant IDs
  Future<Map<String, List<MenuItemModel>>> getMenuItemsByRestaurants(
    List<String> restaurantIds,
  ) async {
    final allItems = await _loadMenuItemsFromJson();
    Map<String, List<MenuItemModel>> result = {};

    for (String restaurantId in restaurantIds) {
      result[restaurantId] =
          allItems.where((item) => item.restaurantId == restaurantId).toList();
    }

    return result;
  }

  // Get menu items by price range
  Future<List<MenuItemModel>> getMenuItemsByPriceRange(
    String restaurantId,
    double minPrice,
    double maxPrice,
  ) async {
    final allItems = await getMenuItems(restaurantId);
    return allItems
        .where((item) => item.price >= minPrice && item.price <= maxPrice)
        .toList();
  }

  // Get popular menu items (could be based on some criteria like high rating in future)
  Future<List<MenuItemModel>> getPopularMenuItems(String restaurantId) async {
    final allItems = await getMenuItems(restaurantId);
    // For now, just return available items sorted by price (descending)
    final popularItems = allItems.where((item) => item.isAvailable).toList();
    popularItems.sort((a, b) => b.price.compareTo(a.price));
    return popularItems.take(5).toList(); // Return top 5
  }

  // Get menu statistics
  Future<Map<String, dynamic>> getMenuStatistics(String restaurantId) async {
    final allItems = await getMenuItems(restaurantId);

    if (allItems.isEmpty) {
      return {
        'totalItems': 0,
        'availableItems': 0,
        'vegetarianItems': 0,
        'nonVegetarianItems': 0,
        'averagePrice': 0.0,
        'priceRange': {'min': 0.0, 'max': 0.0},
        'categoriesCount': 0,
      };
    }

    final availableItems = allItems.where((item) => item.isAvailable).length;
    final vegItems = allItems.where((item) => item.isVegetarian).length;
    final nonVegItems = allItems.where((item) => !item.isVegetarian).length;
    final avgPrice =
        allItems.fold(0.0, (sum, item) => sum + item.price) / allItems.length;
    final prices = allItems.map((item) => item.price).toList()..sort();
    final categories = allItems.map((item) => item.category).toSet();

    return {
      'totalItems': allItems.length,
      'availableItems': availableItems,
      'vegetarianItems': vegItems,
      'nonVegetarianItems': nonVegItems,
      'averagePrice': avgPrice,
      'priceRange': {'min': prices.first, 'max': prices.last},
      'categoriesCount': categories.length,
      'categories': categories.map((cat) => cat.name).toList(),
    };
  }

  // Clear cache (useful for testing or data refresh)
  void clearCache() {
    _cachedMenuItems = null;
    print('Menu items cache cleared');
  }

  // Reload menu items from JSON (useful for testing or manual refresh)
  Future<void> reloadMenuItems() async {
    clearCache();
    await _loadMenuItemsFromJson();
  }
}
