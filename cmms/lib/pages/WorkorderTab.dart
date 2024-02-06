import 'package:cmms/pages/part.dart';
import 'package:cmms/pages/task.dart';
import 'package:cmms/pages/wogeneralview.dart';
import 'package:flutter/material.dart';

class WorkOrderTabView extends StatefulWidget {
  @override
  State<WorkOrderTabView> createState() => _WorkOrderTabViewState();
}

class _WorkOrderTabViewState extends State<WorkOrderTabView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Work Order Tab View'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Tasks'),
              Tab(text: 'Parts'),
              Tab(text: 'Files'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // General Tab
            GeneralView(),
            // Tasks Tab
            TaskListScreen(),
            // Parts Tab
            PartsListScreen(),
            // Files Tab
            Center(
              child: Text('Files Content'),
            ),
          ],
        ),
      ),
    );
  }
}
