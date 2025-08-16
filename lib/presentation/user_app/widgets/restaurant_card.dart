import 'package:flutter/material.dart';
import 'package:mini_zomato_platform/models/restaurant_model.dart';

import '../../../core/utils/enums_utils.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    required this.onTap,
  }) : super(key: key);

  // Helper method to determine if restaurant is open
  bool _isRestaurantOpen() {
    return restaurant.status == RestaurantStatus.open &&
        restaurant.openingHours.isOpenNow();
  }

  // Helper method to get status color
  Color _getStatusColor() {
    switch (restaurant.status) {
      case RestaurantStatus.open:
        return _isRestaurantOpen() ? Colors.green : Colors.orange;
      case RestaurantStatus.closed:
        return Colors.red;
      case RestaurantStatus.temporarilyClosed:
        return Colors.orange;
      case RestaurantStatus.comingSoon:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get status text
  String _getStatusText() {
    switch (restaurant.status) {
      case RestaurantStatus.open:
        return _isRestaurantOpen() ? 'Open' : 'Opens Later';
      case RestaurantStatus.closed:
        return 'Closed';
      case RestaurantStatus.temporarilyClosed:
        return 'Temp Closed';
      case RestaurantStatus.comingSoon:
        return 'Coming Soon';
      default:
        return 'Unknown';
    }
  }

  // Helper method to generate description from available data
  String _getDescription() {
    final cuisineText = restaurant.cuisines.take(2).join(', ');
    final vegStatus = restaurant.vegNonVeg.displayName;
    return '$cuisineText • $vegStatus • ${restaurant.location}';
  }

  // Helper method to estimate delivery time
  String _getDeliveryTime() {
    if (!_isRestaurantOpen()) return '--';

    // Estimate based on restaurant type
    switch (restaurant.type) {
      case RestaurantType.fastCasual:
      case RestaurantType.quickService:
        return '15-25';
      case RestaurantType.cafe:
      case RestaurantType.cloudKitchen:
        return '20-30';
      case RestaurantType.casualDining:
        return '30-40';
      case RestaurantType.fineDining:
        return '45-60';
      case RestaurantType.streetFood:
      case RestaurantType.foodTruck:
        return '10-20';
      default:
        return '25-35';
    }
  }

  // Helper method to estimate price range
  String _getPriceRange() {
    // Estimate based on rating and restaurant type
    if (restaurant.type == RestaurantType.fineDining ||
        restaurant.rating >= 4.5) {
      return '₹₹₹₹';
    } else if (restaurant.type == RestaurantType.casualDining ||
        restaurant.rating >= 4.0) {
      return '₹₹₹';
    } else if (restaurant.type == RestaurantType.cafe ||
        restaurant.rating >= 3.5) {
      return '₹₹';
    } else {
      return '₹';
    }
  }

  // Helper method to estimate review count based on rating
  String _getReviewCount() {
    // Simulate review count based on rating (you can replace this with actual data)
    if (restaurant.rating >= 4.5) {
      return '500+';
    } else if (restaurant.rating >= 4.0) {
      return '200+';
    } else if (restaurant.rating >= 3.5) {
      return '100+';
    } else {
      return '50+';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  restaurant.imageUrl != null
                      ? Image.network(
                        restaurant.imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.restaurant,
                                    size: 40,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                              SizedBox(height: 8),
                              Text(
                                restaurant.name,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                  // Restaurant type badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        restaurant.type.displayName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Veg/Non-Veg indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            restaurant.vegNonVeg == VegNonVeg.veg
                                ? Colors.green
                                : restaurant.vegNonVeg == VegNonVeg.nonVeg
                                ? Colors.red
                                : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        restaurant.vegNonVeg == VegNonVeg.veg
                            ? Icons.eco
                            : Icons.restaurant_menu,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Restaurant Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Status Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),

                  // Description
                  Text(
                    _getDescription(),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),

                  // Cuisine Tags
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children:
                        restaurant.cuisines
                            .take(3)
                            .map(
                              (cuisine) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  cuisine,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 8),

                  // Rating, Reviews, Time, and Price Row
                  Row(
                    children: [
                      // Rating
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${restaurant.rating}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.star, color: Colors.white, size: 12),
                          ],
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${_getReviewCount()})',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Spacer(),

                      // Delivery Time
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${_getDeliveryTime()} mins',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      SizedBox(width: 16),

                      // Price Range
                      Text(
                        _getPriceRange(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
