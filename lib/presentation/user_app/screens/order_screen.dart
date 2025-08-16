import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/order_history/order_history_bloc.dart';
import '../../../bloc/order_history/order_history_event.dart';
import '../../../bloc/order_history/order_history_state.dart';
import '../widgets/order_card.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderHistoryBloc>().add(LoadOrderHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
          if (state is OrderHistoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OrderHistoryLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_outlined, size: 100, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No orders yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Order something delicious!',
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
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: state.orders[index]);
              },
            );
          } else if (state is OrderHistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrderHistoryBloc>().add(LoadOrderHistory());
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
    );
  }
}
