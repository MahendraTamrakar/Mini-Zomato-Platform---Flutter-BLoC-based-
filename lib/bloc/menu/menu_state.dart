import 'package:mini_zomato_platform/models/menu_item_model.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItemModel> menuItems;

  MenuLoaded({required this.menuItems});
}

class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}
