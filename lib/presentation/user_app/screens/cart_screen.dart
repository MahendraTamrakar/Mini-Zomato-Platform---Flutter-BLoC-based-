import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/cart/cart_event.dart';
import '../../../bloc/cart/cart_state.dart';
import '../../../bloc/order/order_bloc.dart';
import '../../../bloc/order/order_event.dart';
import '../../../bloc/order/order_state.dart';
import '../widgets/cartItem_card.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text('Clear Cart'),
                            content: Text(
                              'Are you sure you want to clear the cart?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(ClearCart());
                                  Navigator.pop(context);
                                },
                                child: Text('Clear'),
                              ),
                            ],
                          ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your cart is empty',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add some delicious items to get started!',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () =>
                              Navigator.pushReplacementNamed(context, '/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Browse Restaurants'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return CartItemCard(
                        cartItem: state.items[index],
                        onUpdateQuantity: (quantity) {
                          if (quantity > 0) {
                            context.read<CartBloc>().add(
                              UpdateCartItemQuantity(
                                menuItemId: state.items[index].menuItem.id,
                                quantity: quantity,
                              ),
                            );
                          } else {
                            context.read<CartBloc>().add(
                              RemoveFromCart(
                                menuItemId: state.items[index].menuItem.id,
                              ),
                            );
                          }
                        },
                        onRemove: () {
                          context.read<CartBloc>().add(
                            RemoveFromCart(
                              menuItemId: state.items[index].menuItem.id,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal:'),
                          Text('₹${state.subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Fee:'),
                          Text('₹${state.deliveryFee.toStringAsFixed(2)}'),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹${state.total.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showCheckoutDialog(context, state),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, CartLoaded cartState) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderPlaced) {
                Navigator.pop(dialogContext);
                context.read<CartBloc>().add(ClearCart());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order placed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacementNamed(context, '/orders');
              } else if (state is OrderError) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: AlertDialog(
              title: Text('Delivery Address'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Enter your delivery address',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      if (state is OrderPlacing) {
                        return CircularProgressIndicator();
                      }
                      return Container();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel'),
                ),
                BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state is OrderPlacing
                              ? null
                              : () {
                                if (_addressController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please enter delivery address',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }
                                context.read<OrderBloc>().add(
                                  PlaceOrder(
                                    items: cartState.items,
                                    deliveryAddress:
                                        _addressController.text.trim(),
                                  ),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Place Order'),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}
