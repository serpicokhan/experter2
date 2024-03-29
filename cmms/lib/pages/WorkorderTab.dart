import 'package:cmms/pages/bomlistview.dart';
import 'package:cmms/pages/partlist.dart';
import 'package:cmms/pages/tasklist.dart';
import 'package:cmms/pages/wogeneralview.dart';
import 'package:flutter/material.dart';

class WorkOrderTabView extends StatefulWidget {
  late final int woId;
  WorkOrderTabView({required this.woId});
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
          title: Text('جزییات دستور کار',
              style: TextStyle(fontFamily: 'Vazir', fontSize: 12.0

                  // Add more text styles as needed
                  )),
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
            GeneralView(
              woId: widget.woId,
            ),
            // Tasks Tab
            TaskView(workOrderId: widget.woId),
            // Parts Tab
            PartView(
              workOrderId: widget.woId,
            ),
            // Files Tab
            Center(
              child: Text('پیوست ها',
                  style: TextStyle(fontFamily: 'Vazir', fontSize: 12.0

                      // Add more text styles as needed
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
