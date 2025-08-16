// Menu Category Enum
enum MenuCategory {
  appetizers,
  mains,
  desserts,
  beverages,
  salads,
  soups,
  sides,
  combos,
}

// Restaurant Type Enum
enum RestaurantType {
  fineDining,
  casualDining,
  quickService,
  fastCasual,
  cafe,
  cloudKitchen,
  bakery,
  bar,
  foodTruck,
  streetFood,
}

// Restaurant Status Enum
enum RestaurantStatus { open, closed, temporarilyClosed, comingSoon }

// Vegetarian, non-vegetarian, or both enum
enum VegNonVeg { veg, nonVeg, both }

// Order status enum
enum OrderStatus {
  placed,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

// Extension methods for better display names
extension MenuCategoryExtension on MenuCategory {
  String get displayName {
    switch (this) {
      case MenuCategory.appetizers:
        return 'Appetizers';
      case MenuCategory.mains:
        return 'Main Course';
      case MenuCategory.desserts:
        return 'Desserts';
      case MenuCategory.beverages:
        return 'Beverages';
      case MenuCategory.salads:
        return 'Salads';
      case MenuCategory.soups:
        return 'Soups';
      case MenuCategory.sides:
        return 'Sides';
      case MenuCategory.combos:
        return 'Combos';
    }
  }
}

extension RestaurantTypeExtension on RestaurantType {
  String get displayName {
    switch (this) {
      case RestaurantType.fineDining:
        return 'Fine Dining';
      case RestaurantType.casualDining:
        return 'Casual Dining';
      case RestaurantType.quickService:
        return 'Quick Service';
      case RestaurantType.fastCasual:
        return 'Fast Casual';
      case RestaurantType.cafe:
        return 'Café';
      case RestaurantType.cloudKitchen:
        return 'Cloud Kitchen';
      case RestaurantType.bakery:
        return 'Bakery';
      case RestaurantType.bar:
        return 'Bar';
      case RestaurantType.foodTruck:
        return 'Food Truck';
      case RestaurantType.streetFood:
        return 'Street Food';
    }
  }
}

extension RestaurantStatusExtension on RestaurantStatus {
  String get displayName {
    switch (this) {
      case RestaurantStatus.open:
        return 'Open';
      case RestaurantStatus.closed:
        return 'Closed';
      case RestaurantStatus.temporarilyClosed:
        return 'Temporarily Closed';
      case RestaurantStatus.comingSoon:
        return 'Coming Soon';
    }
  }
}

extension VegNonVegExtension on VegNonVeg {
  String get displayName {
    switch (this) {
      case VegNonVeg.veg:
        return 'Pure Veg';
      case VegNonVeg.nonVeg:
        return 'Non-Veg';
      case VegNonVeg.both:
        return 'Veg & Non-Veg';
    }
  }
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
