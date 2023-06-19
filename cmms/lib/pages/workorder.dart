import 'package:flutter/material.dart';

class WorkOrder {
  final String problem;
  final String asset;
  final DateTime dueDate;
  final String maintenanceType;
  final String status;
  final String priority;

  WorkOrder({
    required this.problem,
    required this.asset,
    required this.dueDate,
    required this.maintenanceType,
    required this.status,
    required this.priority,
  });
}

class WorkOrderListScreen extends StatefulWidget {
  @override
  _WorkOrderListScreenState createState() => _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends State<WorkOrderListScreen> {
  List<WorkOrder> _workOrders = [
    WorkOrder(
      problem: 'Electrical issue',
      asset: 'Building A',
      dueDate: DateTime(2023, 6, 20),
      maintenanceType: 'Routine',
      status: 'Pending',
      priority: 'High',
    ),
    WorkOrder(
      problem: 'Plumbing leak',
      asset: 'Building B',
      dueDate: DateTime(2023, 6, 18),
      maintenanceType: 'Emergency',
      status: 'In Progress',
      priority: 'High',
    ),
    WorkOrder(
      problem: 'HVAC malfunction',
      asset: 'Building C',
      dueDate: DateTime(2023, 6, 22),
      maintenanceType: 'Routine',
      status: 'Completed',
      priority: 'Medium',
    ),
    // Add more work orders as needed
  ];

  List<WorkOrder> _filteredWorkOrders = [];

  TextEditingController _searchController = TextEditingController();

  String _selectedSortBy = 'Date';

  List<String> _selectedStatusFilters = [];

  @override
  void initState() {
    super.initState();
    _filteredWorkOrders = List.from(_workOrders);
  }

  void _sortWorkOrders(String sortBy) {
    setState(() {
      _selectedSortBy = sortBy;

      _filteredWorkOrders.sort((a, b) {
        if (sortBy == 'Date') {
          return a.dueDate.compareTo(b.dueDate);
        } else if (sortBy == 'Problem') {
          return a.problem.compareTo(b.problem);
        } else if (sortBy == 'Asset') {
          return a.asset.compareTo(b.asset);
        }
        return 0;
      });
    });
  }

  void _filterWorkOrders() {
    setState(() {
      _filteredWorkOrders = _workOrders.where((order) {
        if (_selectedStatusFilters.isEmpty) {
          return true;
        } else {
          return _selectedStatusFilters.contains(order.status);
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _filteredWorkOrders = _workOrders.where((order) {
                    return order.problem
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        order.asset.toLowerCase().contains(value.toLowerCase());
                  }).toList();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: [
              FilterChip(
                label: Text('Pending'),
                selected: _selectedStatusFilters.contains('Pending'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatusFilters.add('Pending');
                    } else {
                      _selectedStatusFilters.remove('Pending');
                    }
                    _filterWorkOrders();
                  });
                },
              ),
              FilterChip(
                label: Text('In Progress'),
                selected: _selectedStatusFilters.contains('In Progress'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatusFilters.add('In Progress');
                    } else {
                      _selectedStatusFilters.remove('In Progress');
                    }
                    _filterWorkOrders();
                  });
                },
              ),
              FilterChip(
                label: Text('Completed'),
                selected: _selectedStatusFilters.contains('Completed'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatusFilters.add('Completed');
                    } else {
                      _selectedStatusFilters.remove('Completed');
                    }
                    _filterWorkOrders();
                  });
                },
              ),
            ],
          ),
          ListTile(
            title: Text('Sort by:'),
            trailing: DropdownButton<String>(
              value: _selectedSortBy,
              onChanged: (newValue) => _sortWorkOrders(newValue!),
              items: ['Date', 'Problem', 'Asset']
                  .map<DropdownMenuItem<String>>(
                    (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredWorkOrders.length,
              itemBuilder: (context, index) {
                var workOrder = _filteredWorkOrders[index];
                return ListTile(
                  title: Text(workOrder.problem),
                  subtitle: Text(workOrder.asset),
                  trailing: Text(workOrder.dueDate.toString()),
                  // Add more fields as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
