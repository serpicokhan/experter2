import 'package:flutter/material.dart';

class WorkOrderList extends StatefulWidget {
  @override
  _WorkOrderListState createState() => _WorkOrderListState();
}

class _WorkOrderListState extends State<WorkOrderList> {
  List<WorkOrder> workOrders = [
    WorkOrder('Problem 1', 'Asset 1', DateTime(2023, 6, 1), 'Open', 'High'),
    WorkOrder('Problem 2', 'Asset 2', DateTime(2023, 6, 3), 'Closed', 'Medium'),
    WorkOrder('Problem 3', 'Asset 3', DateTime(2023, 6, 5), 'Open', 'Low'),
    WorkOrder('Problem 4', 'Asset 4', DateTime(2023, 6, 7), 'Open', 'High'),
    WorkOrder('Problem 5', 'Asset 5', DateTime(2023, 6, 9), 'Closed', 'Medium'),
  ];

  bool showClosedWorkOrders = false;
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    List<WorkOrder> filteredWorkOrders = workOrders.where((workOrder) {
      final lowerCaseTerm = searchTerm.toLowerCase();
      return workOrder.problem.toLowerCase().contains(lowerCaseTerm) ||
          workOrder.asset.toLowerCase().contains(lowerCaseTerm);
    }).toList();

    if (!showClosedWorkOrders) {
      filteredWorkOrders = filteredWorkOrders
          .where((workOrder) => workOrder.status != 'Closed')
          .toList();
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchTerm = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Icon(Icons.add),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Show Closed Work Orders'),
                Switch(
                  value: showClosedWorkOrders,
                  onChanged: (value) {
                    setState(() {
                      showClosedWorkOrders = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWorkOrders.length,
              itemBuilder: (context, index) {
                final workOrder = filteredWorkOrders[index];
                return InkWell(
                  onTap: () {
                    // Perform action on work order click
                  },
                  child: ListTile(
                    leading: Icon(Icons.build),
                    title: Text(workOrder.problem),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Asset: ${workOrder.asset}'),
                        Text('Due Date: ${workOrder.dueDate.toString()}'),
                        Text('Status: ${workOrder.status}'),
                        Text('Priority: ${workOrder.priority}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WorkOrder {
  final String problem;
  final String asset;
  final DateTime dueDate;
  final String status;
  final String priority;

  WorkOrder(this.problem, this.asset, this.dueDate, this.status, this.priority);
}
