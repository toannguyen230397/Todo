part of 'dropdown_bloc.dart';

abstract class DropdownEvent {}

class SelectedPlanItem extends DropdownEvent {
  final String planItem;

  SelectedPlanItem({required this.planItem});
}

class SelectedChartItem extends DropdownEvent {
  final String chartItem;

  SelectedChartItem({required this.chartItem});
}