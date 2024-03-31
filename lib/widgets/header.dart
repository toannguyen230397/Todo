import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/dropdown/dropdown_bloc.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/function_helper/datetime_filter.dart';

class Header extends StatefulWidget {
  final String Screen;
  final String Title;
  const Header({required this.Screen, required this.Title});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    bool isHomeScreen = widget.Screen == 'Home';
    bool isPlanScreen = widget.Screen == 'Plan';
    bool isChartScreen = widget.Screen == 'Chart';
    Size screenSize = MediaQuery.of(context).size;

    return Container(
        width: screenSize.width,
        height: screenSize.height * 0.15,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: <Color>[Colors.blue, Colors.white]),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 10, top: 10, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.Title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
              isPlanScreen
                  ? BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, todoState) {
                      return BlocBuilder<DropdownBloc, DropdownState>(
                        builder: (context, dropdownState) {
                          if (todoState is TodoUpdate &&
                              todoState.task.isNotEmpty) {
                            final dateList = todoState.task
                                .map((task) => formatDT(task.date))
                                .toSet()
                                .toList();
                            dropdownState.item == ''
                                ? context
                                    .read<DropdownBloc>()
                                    .add(SelectedItem(item: dateList.first))
                                : null;
                            bool greenFlag =
                                dateList.contains(dropdownState.item);
                            greenFlag == false
                                ? context
                                    .read<DropdownBloc>()
                                    .add(SelectedItem(item: dateList.first))
                                : null;
                            String? selectedItem =
                                greenFlag ? dropdownState.item : dateList.first;
                            return DropdownButton<String>(
                              selectedItemBuilder: (_) {
                                return dateList
                                    .map((e) => Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${formatDate(e)} ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ))
                                    .toList();
                              },
                              value: selectedItem,
                              icon: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.arrow_drop_down),
                              ),
                              items: dateList.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(
                                    formatDate(value),
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                );
                              }).toList(),
                              onChanged: (item) {
                                context
                                    .read<DropdownBloc>()
                                    .add(SelectedItem(item: item.toString()));
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    })
                  : isHomeScreen
                      ? Text(formatDate(DateTime.now().toString()),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20))
                      : isChartScreen
                          ? BlocBuilder<TodoBloc, TodoState>(
                              builder: (context, state) {
                                if (state is TodoUpdate &&
                                    state.task.isNotEmpty) {
                                  String date = formatDT(DateTime.now().toString());
                                  final todoList = state.task
                                      .where((task) => task.date.contains(date))
                                      .toList();
                                  final doneList = todoList
                                      .where((task) => task.isDone == 1)
                                      .toList();
                                  final notDoneList = todoList
                                      .where((task) => task.isDone == 0)
                                      .toList();
                                  return Text('Số công việc hôm nay: ${todoList.length}\nĐã hoàn thành: ${doneList.length} - Chưa hoàn thành: ${notDoneList.length}',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),  
                                        );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          : Container(),
            ],
          ),
        ));
  }
}
