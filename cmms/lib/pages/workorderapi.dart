import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

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
  List<WorkOrder> _workOrders = [];

  List<WorkOrder> _filteredWorkOrders = [];

  TextEditingController _searchController = TextEditingController();

  String _selectedSortBy = 'Date';

  List<String> _selectedStatusFilters = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkOrders();
  }

  Future<void> _fetchWorkOrders() async {
    final response =
        await http.get(Uri.parse('http://192.168.2.60:8000/api/v1/wos2/'));

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source);

      List<WorkOrder> fetchedWorkOrders = [];

      for (var item in data) {
        WorkOrder workOrder = WorkOrder(
          problem: item['summaryofIssue'],
          asset: item['woAsset']["assetName"],
          dueDate: DateTime.parse(item['datecreated']),
          maintenanceType: item['maintenanceType']["name"],
          status: item['status'].toString(),
          priority: '1',
        );

        fetchedWorkOrders.add(workOrder);
      }

      setState(() {
        _workOrders = fetchedWorkOrders;
        _filteredWorkOrders = List.from(_workOrders);
      });
    } else {
      throw Exception('Failed to fetch work orders');
    }
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
                label: Text(
                  'معوق',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12.0, overflow: TextOverflow.ellipsis,

                    // Add more text styles as needed
                  ),
                ),
                selected: _selectedStatusFilters.contains('معوق'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatusFilters.add('معوق');
                    } else {
                      _selectedStatusFilters.remove('معوق');
                    }
                    _filterWorkOrders();
                  });
                },
              ),
              FilterChip(
                label: Text(
                  'در حال پیشرفت',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12.0, overflow: TextOverflow.ellipsis,

                    // Add more text styles as needed
                  ),
                ),
                selected: _selectedStatusFilters.contains('در حال پیشرفت'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatusFilters.add('در حال پیشرفت');
                    } else {
                      _selectedStatusFilters.remove('در حال پیشرفت');
                    }
                    _filterWorkOrders();
                  });
                },
              ),
              FilterChip(
                label: Text(
                  'تکمیل',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12.0, overflow: TextOverflow.ellipsis,

                    // Add more text styles as needed
                  ),
                ),
                selected: _selectedStatusFilters.contains('تکمیل'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatusFilters.add('تکمیل');
                    } else {
                      _selectedStatusFilters.remove('تکمیل');
                    }
                    _filterWorkOrders();
                  });
                },
              ),
            ],
          ),
          ListTile(
            title: Text(
              'مرتب سازی بر اساس:',
              style: TextStyle(
                fontFamily: 'Vazir',

                // Add more text styles as needed
              ),
            ),
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
//                 return ListTile(
//                   title: Text(workOrder.problem),
//                   subtitle: Text(workOrder.asset),
//                   trailing: Text(workOrder.dueDate.toString()),
// // Add more fields as needed
//                 );
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      workOrder.problem,
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 12.0, overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,

                        // Add more text styles as needed
                      ),
                    ),
                    subtitle: Text(
                      workOrder.asset,
                      style: TextStyle(
                        fontFamily: 'Vazir',

                        // Add more text styles as needed
                      ),
                    ),
                    trailing: Text(
                      DateFormat('yyyy-MM-dd').format(workOrder.dueDate),
                    ),
// Add more fields as needed
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
