import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/menu/menu_bloc.dart';
import 'bloc/order/order_bloc.dart';
import 'bloc/order_history/order_history_bloc.dart';
import 'bloc/restaurant_list/restaurant_list_bloc.dart';
import 'core/utils/routes.dart';
import 'presentation/user_app/screens/cart_screen.dart';
import 'presentation/user_app/screens/home_screen.dart';
import 'presentation/user_app/screens/login_screen.dart';
import 'presentation/user_app/screens/order_screen.dart';
import 'presentation/user_app/screens/restaurant_screen.dart';
import 'presentation/user_app/screens/splash_screen.dart';
import 'repositories/auth_repository.dart';
import 'repositories/cart_repository.dart';
import 'repositories/menu_repository.dart';
import 'repositories/order_repository.dart';
import 'repositories/restaurant_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider<RestaurantListBloc>(
          create: (context) => RestaurantListBloc(RestaurantRepository()),
        ),
        BlocProvider<MenuBloc>(create: (context) => MenuBloc(MenuRepository())),
        BlocProvider<CartBloc>(create: (context) => CartBloc(CartRepository())),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(OrderRepository()),
        ),
        BlocProvider<OrderHistoryBloc>(
          create: (context) => OrderHistoryBloc(OrderRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Mini Zomato',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: splashPageRoute,

        routes: {
          splashPageRoute: (context) => SplashScreen(),
          loginPageRoute: (context) => LoginPage(),
          homePageRoute: (context) => HomePage(),
          restaurantPageRoute: (context) => RestaurantPage(),
          cartPageRoute: (context) => CartPage(),
          myOrdersPageRoute: (context) => MyOrdersPage(),
        },
      ),
    );
  }
}
