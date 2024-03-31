import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/function_helper/datetime_filter.dart';
import 'package:todo_app/models/todo.dart';

Widget TaskWidget(BuildContext context, Todo task) {
  bool isDone = task.isDone == 1 ? true : false;
  return Container(
    decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
    padding: EdgeInsets.all(30),
    child: Container(
        child: Row(
      children: [
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: '${task.title}',
                      style: isDone
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.black26)
                          : TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                    ),
                    TextSpan(
                      text: ' / ${formatTime(task.date)}',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Colors.black26),
                    ),
                  ],
                ),
              ),
              Text(
                task.desc,
                style: isDone
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black26)
                    : null,
              )
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: Checkbox(
                  value: isDone,
                  onChanged: (value) {
                    if (isDone == false) {
                      task.isDone = 1;
                      context.read<TodoBloc>().add(UpdateDoneTask(task: task));
                    } else {
                      print('isDone is true');
                    }
                  },
                )),
                InkWell(
                  onTap: () {
                    BottomSheetShow(context: context, task: task);
                  },
                  child: Container(
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.black26,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    )),
  );
}

void BottomSheetShow({required BuildContext context, required Todo task}) {
  Size screenSize = MediaQuery.of(context).size;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                  onTap: () {
                    context.read<TodoBloc>().add(DeleteTask(task: task));
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.black12))),
                      width: screenSize.width,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete),
                          Text(
                            '  Delete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ))),
              InkWell(
                  onTap: () {
                    _showMyDialog(context: context, task: task);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.black12))),
                      width: screenSize.width,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit),
                          Text(
                            '  Edit',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ))),
            ],
          ),
        );
      });
}

Future<void> _showMyDialog(
    {required BuildContext context, required Todo task}) async {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextField(controller: titleController, hint: 'Title'),
            buildTextField(controller: descController, hint: 'Desc')
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Quay Lại',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              String title = titleController.text;
              String desc = descController.text;
              final newTask = Todo(
                  id: task.id,
                  title: title,
                  desc: desc,
                  date: task.date,
                  notiID: task.notiID,
                  isDone: task.isDone);
              context.read<TodoBloc>().add(Updatetask(task: newTask));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Xác Nhận',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildTextField(
    {required TextEditingController controller,
    required String hint,
    int? length}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
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
