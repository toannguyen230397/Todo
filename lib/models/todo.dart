class Todo {
  final int id;
  final String title;
  final String desc;
  final String date;
  final int notiID;
  int isDone;

  Todo({
    required this.id,
    required this.title,
    required this.desc,
    required this.date,
    required this.notiID,
    this.isDone = 0,
  });
}