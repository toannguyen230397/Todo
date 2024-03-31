import 'package:flutter_bloc/flutter_bloc.dart';
part 'dropdown_event.dart';
part 'dropdown_state.dart';

class DropdownBloc extends Bloc<DropdownEvent, DropdownState> {
  DropdownBloc() : super(DropdownInitial(item: '')) {
    on<SelectedItem>(_SelectedItem);
  }

  void _SelectedItem (SelectedItem event, Emitter<DropdownState> emit) async {
    state.item = event.item;
    print(state.item);
    emit(DropdownUpdate(item: state.item));
  }
}