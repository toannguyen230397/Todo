import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/function_helper/datetime_filter.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/widgets/emty_data_widget.dart';
import 'package:todo_app/widgets/header.dart';
import 'package:todo_app/widgets/task_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    void goNextPage() {
      FocusManager.instance.primaryFocus?.unfocus();
      pageController.animateToPage(1,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }

    void goPreviousPage() {
      pageController.animateToPage(0,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }

    return Scaffold(
      body: SafeArea(child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial) {
            context.read<TodoBloc>().add(LoadData());
          }
          if (state is TodoLoading) {
            return Column(
              children: [
                Header(Screen: 'Home', Title: 'Công Việc Hôm Nay',),
                Expanded(
                    child: Center(
                  child: CircularProgressIndicator(),
                ))
              ],
            );
          }
          if (state is TodoUpdate && state.task.isNotEmpty) {
            String date = formatDT(DateTime.now().toString());
            final todoList = state.task.where((task) => task.date.contains(date)).toList();
            return PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Column(
                  children: [
                    Header(Screen: 'Home', Title: 'Công Việc Hôm Nay'),
                    Expanded(
                      child: todoList.isNotEmpty
                      ? ShaderMask(
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
                          ))
                      : EmptyDataWidget(Label: 'Không có dữ liệu! hãy thêm công việc mới')  
                    ),
                    addButton(goNextPage: goNextPage)
                  ],
                ),
                AddTaskScreen(goPreviousPage: goPreviousPage)
              ],
            );
          } else {
            return PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Column(
                  children: [
                    Header(Screen: 'Home', Title: 'Công Việc Hôm Nay',),
                    Expanded(
                      child: EmptyDataWidget(Label: 'Không có dữ liệu! hãy thêm công việc mới')
                    ),
                    addButton(goNextPage: goNextPage)
                  ],
                ),
                AddTaskScreen(goPreviousPage: goPreviousPage)
              ],
            );
          }
        },
      )),
    );
  }

  Widget addButton({required Function goNextPage}) {
    return InkWell(
      onTap: () {
        goNextPage();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 40, right: 40),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              blurRadius: 15.0,
              spreadRadius: -20.0,
              offset: Offset(0.0, 25.0),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              'Thêm Công Việc Mới',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
      required String hint,
      int? length}) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 40),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.blueGrey,
            blurRadius: 20.0,
            spreadRadius: -20.0,
            offset: Offset(0.0, 25.0),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        maxLength: length,
        style: TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.black26, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
