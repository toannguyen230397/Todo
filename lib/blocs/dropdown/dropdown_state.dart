part of 'dropdown_bloc.dart';

abstract class DropdownState {
  String item;
  DropdownState({required this.item});
}

class DropdownInitial extends DropdownState {
  DropdownInitial({required String item}) : super(item: item);
}

class DropdownUpdate extends DropdownState {
  DropdownUpdate({required String item}) : super(item: item);
}