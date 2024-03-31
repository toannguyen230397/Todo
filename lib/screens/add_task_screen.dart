import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/function_helper/datetime_filter.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets/header.dart';

class AddTaskScreen extends StatefulWidget {
  final Function goPreviousPage;
  const AddTaskScreen({required this.goPreviousPage});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void dateTimePicker(TextEditingController dateController) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true, minTime: DateTime.now(), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      setState(() {
        dateController.text = date.toString();
      });
      print(dateController.text);
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              Screen: 'AddTask',
              Title: 'Thêm Công Việc Mới',
            ),
            buildTextField(
                controller: titleController, hint: 'Nhập tiêu đề', length: 20),
            buildTextField(
                controller: descController, hint: 'Nhập nội dung', length: 50),
            InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                dateTimePicker(dateController);
              },
              child: Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.055,
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 40, right: 40),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.blueGrey.shade300,
                        blurRadius: 20.0,
                        spreadRadius: -20.0,
                        offset: Offset(0.0, 25.0),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 9,
                          child: Text(
                            dateController.text == ''
                                ? 'Chọn lịch hẹn'
                                : formatDateTime(dateController.text),
                            style: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(flex: 1, child: Icon(Icons.arrow_drop_down))
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      widget.goPreviousPage();
                    },
                    child: Text(
                      'Quay Lại',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      int id = DateTime.now().millisecondsSinceEpoch;
                      String title = titleController.text;
                      String desc = descController.text;
                      String date = dateController.text;
                      int notiID = Random().nextInt(1000);
                      bool redFlag =
                          title.isEmpty || desc.isEmpty || date.isEmpty;
                      if (redFlag) {
                        _showMyDialog();
                      } else {
                        final task = Todo(
                            id: id,
                            title: title,
                            desc: desc,
                            date: date,
                            notiID: notiID,
                            isDone: 0);
                        context.read<TodoBloc>().add(AddTask(task: task));
                        widget.goPreviousPage();
                      }
                    },
                    child: Text(
                      'Xác Nhận',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget buildTextField(
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Vui lòng nhập đủ thông tin!'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.of(context).pop();
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
}
