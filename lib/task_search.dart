import 'package:flutter/material.dart';
import 'package:todo_app_project/model.dart';

class TaskSearch extends SearchDelegate<TodoModel> {
  List<TodoModel> dataList;

  TaskSearch({required this.dataList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, TodoModel());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement your search logic here
    List<TodoModel> searchResults = dataList
        .where((task) =>
            task.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        TodoModel task = searchResults[index];

        return ListTile(
          title: Text(task.title!),
          onTap: () {
            close(context, task);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement your suggestion logic here
    List<TodoModel> searchResults = dataList
        .where((task) =>
            task.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        TodoModel task = searchResults[index];

        return ListTile(
          title: Text(task.title!),
          onTap: () {
            close(context, task);
          },
        );
      },
    );
  }
}
