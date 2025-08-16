import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/restaurant_list/restaurant_list_bloc.dart';
import '../../../bloc/restaurant_list/restaurant_list_event.dart';
import '../../../bloc/restaurant_list/restaurant_list_state.dart';
import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/cart/cart_event.dart';
import '../../../bloc/cart/cart_state.dart';
import '../widgets/restaurant_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RestaurantListBloc>().add(LoadRestaurants());
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Zomato'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.items.fold(
                  0,
                  (sum, item) => sum + item.quantity,
                );
              }
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$itemCount',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.history),
                      title: Text('My Orders'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    value: 'orders',
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    value: 'logout',
                  ),
                ],
            onSelected: (value) {
              if (value == 'orders') {
                Navigator.pushNamed(context, '/orders');
              } else if (value == 'logout') {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<RestaurantListBloc>().add(LoadRestaurants());
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<RestaurantListBloc>().add(
                    SearchRestaurants(query: value),
                  );
                } else {
                  context.read<RestaurantListBloc>().add(LoadRestaurants());
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(
                  label: Text('Open Now'),
                  onSelected: (selected) {
                    if (selected) {
                      context.read<RestaurantListBloc>().add(
                        FilterRestaurants(filter: 'open'),
                      );
                    } else {
                      context.read<RestaurantListBloc>().add(LoadRestaurants());
                    }
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('High Rated'),
                  onSelected: (selected) {
                    if (selected) {
                      context.read<RestaurantListBloc>().add(
                        FilterRestaurants(filter: 'rating'),
                      );
                    } else {
                      context.read<RestaurantListBloc>().add(LoadRestaurants());
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<RestaurantListBloc, RestaurantListState>(
              builder: (context, state) {
                if (state is RestaurantListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is RestaurantListLoaded) {
                  if (state.restaurants.isEmpty) {
                    return Center(child: Text('No restaurants found'));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: state.restaurants.length,
                    itemBuilder: (context, index) {
                      return RestaurantCard(
                        restaurant: state.restaurants[index],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/restaurant',
                            arguments: state.restaurants[index],
                          );
                        },
                      );
                    },
                  );
                } else if (state is RestaurantListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.message}',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RestaurantListBloc>().add(
                              LoadRestaurants(),
                            );
                          },
                          child: Text('Retry'),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
