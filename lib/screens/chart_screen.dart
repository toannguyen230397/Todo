import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/function_helper/datetime_filter.dart';
import 'package:todo_app/widgets/emty_data_widget.dart';
import 'package:todo_app/widgets/header.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              Screen: 'Chart',
              Title: 'Thống kê hôm nay',
            ),
            Expanded(child:
                BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
              if (state is TodoUpdate && state.task.isNotEmpty) {
                String date = formatDT(DateTime.now().toString());
                final todoList = state.task
                    .where((task) => task.date.contains(date))
                    .toList();
                if (todoList.isNotEmpty) {
                  final doneList =
                      todoList.where((task) => task.isDone == 1).toList();

                  int doneNumber() {
                    int doneNumber =
                        ((doneList.length / todoList.length) * 100).round();
                    return doneNumber;
                  }

                  int notDoneNumber = 100 - doneNumber();

                  print(doneNumber);

                  List<GDPData> chartData = [
                    GDPData(continent: 'Đã Hoàn Thành', gdp: doneNumber()),
                    GDPData(continent: 'Chưa Hoàn Thành', gdp: notDoneNumber),
                  ];
                  return SfCircularChart(
                    series: <CircularSeries>[
                      PieSeries<GDPData, String>(
                        dataSource: chartData,
                        xValueMapper: (GDPData data, _) => data.continent,
                        yValueMapper: (GDPData data, _) => data.gdp,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(fontSize: 18)),
                      )
                    ],
                    legend: Legend(
                        position: LegendPosition.bottom,
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: TextStyle(fontSize: 18)),
                  );
                } else {
                  return Center(
                    child: EmptyDataWidget(Label: 'Không Có Dữ Liệu Thống Kê'),
                  );
                }
              } else {
                return Center(
                  child: EmptyDataWidget(Label: 'Không Có Dữ Liệu Thống Kê'),
                );
              }
            })),
          ],
        ),
      ),
    );
  }
}

class GDPData {
  final String continent;
  final int gdp;
  GDPData({required this.continent, required this.gdp});
}
