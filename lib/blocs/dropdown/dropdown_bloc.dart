import 'package:flutter_bloc/flutter_bloc.dart';
part 'dropdown_event.dart';
part 'dropdown_state.dart';

class DropdownBloc extends Bloc<DropdownEvent, DropdownState> {
  DropdownBloc() : super(DropdownInitial(planItem: '', chartItem: '')) {
    on<SelectedPlanItem>(_SelectedPlanItem);
    on<SelectedChartItem>(_SelectedChartItem);
  }

  void _SelectedPlanItem (SelectedPlanItem event, Emitter<DropdownState> emit) async {
    state.planItem = event.planItem;
    emit(DropdownUpdate(planItem: state.planItem, chartItem: state.chartItem));
  }

  void _SelectedChartItem (SelectedChartItem event, Emitter<DropdownState> emit) async {
    state.chartItem = event.chartItem;
    emit(DropdownUpdate(planItem: state.planItem, chartItem: state.chartItem));
  }
}