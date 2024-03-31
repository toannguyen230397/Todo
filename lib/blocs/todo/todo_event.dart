part of 'todo_bloc.dart';

abstract class TodoEvent {}

class AddTask extends TodoEvent {
  final Todo task;

  AddTask({required this.task});
}

class DeleteTask extends TodoEvent {
  final Todo task;

  DeleteTask({required this.task});
}

class Updatetask extends TodoEvent {
  final Todo task;

  Updatetask({required this.task});
}

class UpdateDoneTask extends TodoEvent {
  final Todo task;

  UpdateDoneTask({required this.task});
}

class LoadData extends TodoEvent {}