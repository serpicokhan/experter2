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
            Center(
              child: Text('General Content'),
            ),
            // Tasks Tab
            Center(
              child: Text('Tasks Content'),
            ),
            // Parts Tab
            Center(
              child: Text('Parts Content'),
            ),
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
