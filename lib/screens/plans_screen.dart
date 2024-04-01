import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/dropdown/dropdown_bloc.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/widgets/emty_data_widget.dart';
import 'package:todo_app/widgets/header.dart';
import 'package:todo_app/widgets/task_widget.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<DropdownBloc, DropdownState>(
          builder: (context, dropdownState) {
        return Column(
          children: [
            Header(
              Screen: 'Plan',
              Title: 'Kế Hoạch Sắp Tới',
            ),
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, todoState) {
                if (todoState is TodoUpdate && todoState.task.isNotEmpty && dropdownState.item != '') {
                  String date = dropdownState.item;
                  final todoList = todoState.task
                      .where((task) => task.date.contains(date))
                      .toList();
                  if(todoList.isEmpty) {
                    return Center(
                      child: EmptyDataWidget(Label: 'Không có kế hoạch nào để hiển thị'),
                    );
                  } else {
                    return ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.black87,
                            Colors.transparent
                          ],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: ListView.builder(
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          final todo = todoList[index];
                          return TaskWidget(context, todo);
                        },
                      ));
                  }
                } else {
                  return Center(
                    child: EmptyDataWidget(Label: 'Không có kế hoạch nào để hiển thị'),
                  );
                }
              }),
            ),
          ],
        );
      })),
    );
  }
}
