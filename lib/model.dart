class TodoModel {
  final int? id;
  final String? title;
  final String? dateandtime;
  final DateTime? dueDateTime;

  TodoModel({
    this.id,
    this.title,
    this.dateandtime,
    this.dueDateTime,
  });

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        dateandtime = res['dateandtime'],
        dueDateTime = DateTime.now(); // Initialize dueDateTime with the current date and time

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "dateandtime": dateandtime,
    };
  }
}
