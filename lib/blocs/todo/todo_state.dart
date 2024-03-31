part of 'todo_bloc.dart';

abstract class TodoState {
  List<Todo> task;
  TodoState({required this.task});
}

class TodoInitial extends TodoState {
  TodoInitial({required List<Todo> task}) : super(task: task);
}

class TodoUpdate extends TodoState {
  TodoUpdate({required List<Todo> task}) : super(task: task);
}

class TodoLoading extends TodoState {
  TodoLoading() : super(task: []);
}