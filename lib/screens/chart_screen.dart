import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:todo_app/blocs/dropdown/dropdown_bloc.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/function_helper/datetime_filter.dart';
import 'package:todo_app/widgets/emty_data_widget.dart';
import 'package:todo_app/widgets/header.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: BlocBuilder<DropdownBloc, DropdownState>(
          builder: (context, dropdownState) {
            return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
              if (state is TodoUpdate && state.task.isNotEmpty) {
                String selectedDate = dropdownState.chartItem;
                String date = selectedDate != ''
                    ? selectedDate
                    : formatDT(DateTime.now().toString());
                final todoList = state.task
                    .where((task) => task.date.contains(date))
                    .toList();
                if (todoList.isNotEmpty) {
                  final doneList =
                      todoList.where((task) => task.isDone == 1).toList();

                  final notDoneList =
                      todoList.where((task) => task.isDone == 0).toList();

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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(
                        Screen: 'Chart',
                        Title: '',
                      ),
                      Container(
                        height: screenSize.height * 0.5,
                        child: SfCircularChart(
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
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'Hoàn Thành:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                          width: screenSize.width,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.black12))),
                          child: doneList.isNotEmpty
                              ? taskListBuilder(list: doneList, type: 'done')
                              : Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    'Chưa có công việc nào bạn đã hoàn thành hết',
                                    style: TextStyle(color: Colors.black26),
                                  ))),
                      ////////////////////////////////////////////////////////////////////////////////
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'Chưa Hoàn Thành:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                          width: screenSize.width,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.black12))),
                          child: notDoneList.isNotEmpty
                              ? taskListBuilder(list: notDoneList, type: 'notDone')
                              : Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    'Bạn đã hoàn thành hết rồi',
                                    style: TextStyle(color: Colors.black26),
                                  )))
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Header(
                        Screen: 'Chart',
                        Title: '',
                      ),
                      EmptyDataWidget(Label: 'Không Có Dữ Liệu Thống Kê')
                    ],
                  );
                }
              } else {
                return Column(
                  children: [
                    Header(
                      Screen: 'Chart',
                      Title: '',
                    ),
                    EmptyDataWidget(Label: 'Không Có Dữ Liệu Thống Kê')
                  ],
                );
              }
            });
          },
        )),
      ),
    );
  }
}

Widget taskListBuilder({required List list, required String type}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: list.length,
    itemBuilder: (context, index) {
      final item = list[index];
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: type == 'done' ? Colors.green : Colors.red,
                child: Icon(
                  type == 'done'
                  ? Icons.check_circle
                  : Icons.dangerous,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'công việc:  ',
                          style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '${item.title} / ${item.desc}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'thời gian:  ',
                            style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '${formatTime(item.date)}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      );
    },
  );
}

class GDPData {
  final String continent;
  final int gdp;
  GDPData({required this.continent, required this.gdp});
}
