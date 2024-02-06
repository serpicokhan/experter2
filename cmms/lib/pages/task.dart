import 'package:flutter/material.dart';

class Task {
  final String type;
  final String title;
  final IconData icon;
  final DateTime date;
  final String user;

  Task({
    required this.type,
    required this.title,
    required this.icon,
    required this.date,
    required this.user,
  });
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> tasks = [
    Task(
      type: 'Type 1',
      title: 'Task 1',
      icon: Icons.task,
      date: DateTime.now(),
      user: 'John Doe',
    ),
    Task(
      type: 'Type 2',
      title: 'Task 2',
      icon: Icons.task,
      date: DateTime.now(),
      user: 'Jane Smith',
    ),
    // Add more tasks here as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(tasks[index].title),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.green,
              alignment: Alignment.centerRight,
              child: Icon(Icons.done, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                if (direction == DismissDirection.startToEnd) {
                  // Delete task
                  tasks.removeAt(index);
                } else if (direction == DismissDirection.endToStart) {
                  // Mark task as done or move to another list
                  // You can implement your logic here
                  tasks.removeAt(index);
                }
              });
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(tasks[index].icon),
                title: Text(tasks[index].title),
                subtitle: Text(
                  'Type: ${tasks[index].type}\n'
                  'Date: ${tasks[index].date.toString()}\n'
                  'User: ${tasks[index].user}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
