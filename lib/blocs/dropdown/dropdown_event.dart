part of 'dropdown_bloc.dart';

abstract class DropdownEvent {}

class SelectedItem extends DropdownEvent {
  final String item;

  SelectedItem({required this.item});
}