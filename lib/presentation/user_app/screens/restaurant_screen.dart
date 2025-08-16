import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_zomato_platform/models/restaurant_model.dart';
import '../../../bloc/menu/menu_bloc.dart';
import '../../../bloc/menu/menu_event.dart';
import '../../../bloc/menu/menu_state.dart';
import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/cart/cart_event.dart';
import '../../../core/utils/enums_utils.dart';
import '../widgets/menu_card.dart';

class RestaurantPage extends StatefulWidget {
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final restaurant =
        ModalRoute.of(context)?.settings.arguments as RestaurantModel?;
    if (restaurant != null) {
      context.read<MenuBloc>().add(LoadMenu(restaurantId: restaurant.id));
    }
  }

  String _formatCategoryName(MenuCategory category) {
    switch (category) {
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
      default:
        return category.name.toUpperCase();
    }
  }

  String _getDeliveryTime(RestaurantModel restaurant) {
    // Since deliveryTime doesn't exist, we'll estimate based on restaurant status
    switch (restaurant.status) {
      case RestaurantStatus.open:
        return '25-35'; // Default delivery time
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

  Color _getStatusColor(RestaurantStatus status) {
    switch (status) {
      case RestaurantStatus.open:
        return Colors.green;
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

  String _getStatusText(RestaurantStatus status) {
    switch (status) {
      case RestaurantStatus.open:
        return 'Open';
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

  String _getPriceRange(RestaurantModel restaurant) {
    // Since priceRange doesn't exist, we'll estimate based on rating
    if (restaurant.rating >= 4.0) {
      return '₹₹₹'; // Premium
    } else if (restaurant.rating >= 3.0) {
      return '₹₹'; // Mid-range
    } else {
      return '₹'; // Budget
    }
  }

  String _getRestaurantDescription(RestaurantModel restaurant) {
    // Generate description from available data
    final cuisineText = restaurant.cuisines.join(', ');
    final vegStatus =
        restaurant.vegNonVeg == VegNonVeg.veg
            ? 'Pure Veg'
            : restaurant.vegNonVeg == VegNonVeg.nonVeg
            ? 'Non-Veg'
            : 'Veg & Non-Veg';
    return '$cuisineText • $vegStatus • ${restaurant.location}';
  }

  @override
  Widget build(BuildContext context) {
    final restaurant =
        ModalRoute.of(context)?.settings.arguments as RestaurantModel?;

    if (restaurant == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Restaurant')),
        body: Center(child: Text('Restaurant not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Restaurant Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image:
                  restaurant.imageUrl != null
                      ? DecorationImage(
                        image: NetworkImage(restaurant.imageUrl!),
                        fit: BoxFit.cover,
                      )
                      : null,
              color: restaurant.imageUrl == null ? Colors.grey[300] : null,
            ),
            child:
                restaurant.imageUrl == null
                    ? Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    )
                    : null,
          ),

          // Restaurant Info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 4),
                Text(
                  _getRestaurantDescription(restaurant),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 20),
                    SizedBox(width: 4),
                    Text('${restaurant.rating}'),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, color: Colors.grey, size: 20),
                    SizedBox(width: 4),
                    Text('${_getDeliveryTime(restaurant)} mins'),
                    SizedBox(width: 16),
                    Text(
                      _getPriceRange(restaurant),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 16),
                    // Restaurant Status
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(restaurant.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(restaurant.status),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      restaurant.cuisines
                          .map(
                            (cuisine) => Chip(
                              label: Text(cuisine),
                              backgroundColor: Colors.grey[200],
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          Divider(),

          // Menu Items
          Expanded(
            child: BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                if (state is MenuLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MenuLoaded) {
                  if (state.menuItems.isEmpty) {
                    return Center(child: Text('No menu items available'));
                  }

                  // Group by MenuCategory enum instead of string
                  final categories = <MenuCategory>{};
                  for (final item in state.menuItems) {
                    categories.add(item.category);
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, categoryIndex) {
                      final category = categories.elementAt(categoryIndex);
                      final categoryItems =
                          state.menuItems
                              .where((item) => item.category == category)
                              .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              _formatCategoryName(category),
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                          ...categoryItems
                              .map(
                                (menuItem) => Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: MenuItemCard(
                                    menuItem: menuItem,
                                    onAddToCart: (quantity) {
                                      context.read<CartBloc>().add(
                                        AddToCart(
                                          menuItem: menuItem,
                                          quantity: quantity,
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${menuItem.name} added to cart',
                                          ),
                                          duration: Duration(seconds: 1),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      );
                    },
                  );
                } else if (state is MenuError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Error loading menu',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<MenuBloc>().add(
                              LoadMenu(restaurantId: restaurant.id),
                            );
                          },
                          child: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
