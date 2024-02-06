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
          title: Text('جزییات دستور کار'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'عمومی'),
              Tab(text: 'کارها'),
              Tab(text: 'قطعات'),
              Tab(text: 'فایلها'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // General Tab
            GeneralView(),
            // Tasks Tab
            Center(
              child: Text('کارها'),
            ),
            // Parts Tab
            Center(
              child: Text('قطعات'),
            ),
            // Files Tab
            Center(
              child: Text('پیوست ها'),
            ),
          ],
        ),
      ),
    );
  }
}
