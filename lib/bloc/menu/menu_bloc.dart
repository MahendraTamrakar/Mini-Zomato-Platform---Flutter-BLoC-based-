import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository;

  MenuBloc(this._menuRepository) : super(MenuInitial()) {
    on<LoadMenu>(_onLoadMenu);
  }

  Future<void> _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final menuItems = await _menuRepository.getMenuItems(event.restaurantId);
      emit(MenuLoaded(menuItems: menuItems));
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }
}
