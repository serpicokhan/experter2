import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Task {
  final int id;
  final String taskTypes;

  final String description;

  Task({required this.id, required this.description, required this.taskTypes});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      taskTypes: json['taskTypes'][1].toString(),
      description: json['taskDescription'] ?? '',
    );
  }
}

class TaskView extends StatefulWidget {
  final int workOrderId;

  TaskView({Key? key, required this.workOrderId}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks(widget.workOrderId);
  }

  Future<void> _fetchTasks(int workOrderId) async {
    // Replace the URL with your actual endpoint that returns tasks for a given workOrderId
    final response = await http.get(Uri.parse(
        '${MyGlobals.server}/api/v1/WorkOrder/${widget.workOrderId}/Tasks'));

    if (response.statusCode == 200) {
      List<dynamic> tasksJson = json.decode(response.body);
      setState(() {
        _tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
      });
    } else {
      // Handle error
      print('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            Task task = _tasks[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.task, color: Colors.deepPurple),
                title: Text(
                  task.description,
                  style: TextStyle(
                    fontFamily: 'Vazir', // Specify your custom font
                    fontSize: 18.0, // Adjust the size as needed
                  ),
                ),
                subtitle: Text(
                  task.taskTypes,
                  style: TextStyle(
                    fontFamily: 'Vazir', // Specify your custom font
                    fontSize: 14.0, // Adjust the size as needed
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
