import 'package:alarm/alarm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/database/sqflite_helper.dart';
import 'package:todo_app/function_helper/local_noti.dart';
import 'package:todo_app/models/todo.dart';
part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial(task: [])) {
    on<AddTask>(_AddTask);
    on<DeleteTask>(_DeleteTask);
    on<Updatetask>(_UpdateTask);
    on<UpdateDoneTask>(_UpdateDoneTask);
    on<LoadData>(_LoadData);
  }

  void _AddTask (AddTask event, Emitter<TodoState> emit) async {
    await TodoDataBase().AddTaskDatabase(event.task);
    state.task.add(event.task);
    setNoti(event.task.date, event.task.title, event.task.desc, event.task.notiID);
    emit(TodoUpdate(task: state.task));
  }

  void _DeleteTask (DeleteTask event, Emitter<TodoState> emit) async {
    await TodoDataBase().DeleteTaskDatabase(event.task);
    state.task.remove(event.task);
    await Alarm.stop(event.task.notiID);
    emit(TodoUpdate(task: state.task));
  }

  void _UpdateTask (Updatetask event, Emitter<TodoState> emit) async {
    for (int i = 0; i < state.task.length; i++) {
      if (event.task.id == state.task[i].id) {
        state.task[i] = event.task;
      }
    }
    await TodoDataBase().UpdateTaskDatabase(event.task);
    emit(TodoUpdate(task: state.task));
  }

   void _UpdateDoneTask (UpdateDoneTask event, Emitter<TodoState> emit) async {
    for (int i = 0; i < state.task.length; i++) {
      if (event.task.id == state.task[i].id) {
        state.task[i] = event.task;
      }
    }
    await Alarm.stop(event.task.notiID);
    await TodoDataBase().UpdateDoneTaskDatabase(event.task);
    emit(TodoUpdate(task: state.task));
  }

  void _LoadData(LoadData event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final taskList = await TodoDataBase().GetAllDataFromDatabase();
    if(taskList.isNotEmpty) {
      emit(TodoUpdate(task: taskList));
    } else {
      emit(TodoUpdate(task: []));
    }
  }
}