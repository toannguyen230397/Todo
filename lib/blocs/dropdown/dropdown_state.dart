part of 'dropdown_bloc.dart';

abstract class DropdownState {
  String planItem;
  String chartItem;
  DropdownState({required this.planItem, required this.chartItem});
}

class DropdownInitial extends DropdownState {
  DropdownInitial({required String planItem, required String chartItem}) : super(planItem: planItem, chartItem: chartItem);
}

class DropdownUpdate extends DropdownState {
  DropdownUpdate({required String planItem, required String chartItem}) : super(planItem: planItem, chartItem: chartItem);
}