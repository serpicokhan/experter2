import 'package:cmms/model/workorder.dart';
import 'package:cmms/pages/WorkorderTab.dart';
import 'package:cmms/pages/workorderform.dart';
import 'package:cmms/util/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart' hide TextDirection;
import 'package:shared_preferences/shared_preferences.dart';

class WorkOrderListScreen extends StatefulWidget {
  @override
  _WorkOrderListScreenState createState() => _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends State<WorkOrderListScreen> {
  List<WorkOrder> _workOrders = [];

  List<WorkOrder> _filteredWorkOrders = [];

  TextEditingController _searchController = TextEditingController();
  TextEditingController _assetController = TextEditingController();
  List<Asset> _assets = []; // List to store the fetched assets
  int assetId = 0;
  String _selectedSortBy = 'Date';
  String? token = '';

  List<String> _selectedStatusFilters = [];

  @override
  void initState() {
    super.initState();
    readData();
    _fetchWorkOrders();
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    final response =
        await http.get(Uri.parse('${MyGlobals.server}/api/v1/locations/'));
    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body);
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source);
      List<Asset> fetchedAssets = [];
      for (var item in data) {
        Asset asset = Asset(
          id: item['id'],
          name: item['assetName'],
        );
        fetchedAssets.add(asset);
      }
      setState(() {
        _assets = fetchedAssets;
      });
    } else {
      throw Exception('Failed to fetch assets');
    }
  }

  void _showAssetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _searchAssetController = TextEditingController();
        // _searchAssetController.text = getfcm() as String;
        return StatefulBuilder(
          builder: (context, setState) {
            List<Asset> filteredAssets = _assets.where((asset) {
              final searchQuery = _searchAssetController.text.toLowerCase();
              return asset.name.toLowerCase().contains(searchQuery);
            }).toList();

            return AlertDialog(
              title: Text('مکان'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchAssetController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'جستجو',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredAssets.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            filteredAssets[index].name,
                            style: TextStyle(fontFamily: 'Vazir'),
                          ),
                          onTap: () {
                            setState(() {
                              _assetController.text =
                                  filteredAssets[index].name;
                              assetId = filteredAssets[index].id;
                              _fetchWorkOrders();
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Read a string value
    token = prefs.getString('token');

    // Read an int value
  }

  Future<void> _fetchWorkOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Read a string value
    token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('${MyGlobals.server}/api/v1/wos2/?assetID=$assetId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode({
        'Authorization': 'Token $token',
      }),
    );
    // final response = await http.get(Uri.parse(
    //     '${MyGlobals.server}/api/v1/wos2/?assetID=$assetId&token=' +
    //         (token ?? '')));

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source);

      List<WorkOrder> fetchedWorkOrders = [];

      for (var item in data) {
        WorkOrder workOrder = WorkOrder(
          id: item['id'],
          problem: item['summaryofIssue'] ?? '',
          asset: item['woAsset']["assetName"] ?? '',
          dueDate: DateTime.parse(item['datecreated']),
          maintenanceType: item['maintenanceType']["name"],
          status: item['woStatus'].toString(),
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

  void _handleDismiss(WorkOrder workOrder) {
    setState(() {
      _filteredWorkOrders.remove(workOrder);
    });

    _makeApiCall(workOrder);
  }

  Future<void> _makeApiCall(WorkOrder workOrder) async {
    // Your API call code goes here
    // Replace the URL with your actual API endpoint
    final int assetid = assetId;
    final response = await http.post(
      Uri.parse('${MyGlobals.server}/api/v1/WO/Complete/?assetID=' +
          assetid.toString()),
      body: {
        'id': workOrder.id.toString(),
        // 'asset': workOrder.asset,
        // Add more parameters as needed
      },
    );

    if (response.statusCode == 200) {
      // API call was successful
      print('API call successful');
      workOrder.setStatus('7');
    } else {
      // API call failed
      print('API call failed');
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings'),
          // Add your settings UI here
        );
      },
    );
  }

  Future<String?> getfcm() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }

  void _displayModalForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Modal Form',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Perform form submission logic here
                  Navigator.of(context).pop(); // Close the modal form
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دستور کارها', style: TextStyle(fontFamily: 'Vazir')),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: TextField(
          //     controller: _searchController,
          //     onChanged: (value) {
          //       setState(() {
          //         _filteredWorkOrders = _workOrders.where((order) {
          //           return order.problem
          //                   .toLowerCase()
          //                   .contains(value.toLowerCase()) ||
          //               order.asset.toLowerCase().contains(value.toLowerCase());
          //         }).toList();
          //       });
          //     },
          //     decoration: InputDecoration(
          //       labelText: 'جستجو',
          //       suffixIcon: IconButton(
          //         onPressed: () => _searchController.clear(),
          //         icon: Icon(Icons.clear),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _assetController,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _showAssetDialog();
              },
              decoration: InputDecoration(
                labelText: 'مکان',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _assetController.clear();
                      assetId = 0;
                      _fetchWorkOrders();
                    });
                  },
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: [
              FilterChip(
                backgroundColor: Colors.blue[50],
                label: Text(
                  'درخواست شده',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12.0,
                    overflow: TextOverflow.ellipsis,

                    // Add more text styles as needed
                  ),
                ),
                selected: _selectedStatusFilters.contains('1'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatusFilters.add('1');
                    } else {
                      _selectedStatusFilters.remove('1');
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
                selected: _selectedStatusFilters.contains('7'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatusFilters.add('7');
                    } else {
                      _selectedStatusFilters.remove('7');
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
                IconData statusIcon;

                // Set the icon based on the status
                if (workOrder.status == '1') {
                  statusIcon = Icons.warning;
                } else if (workOrder.status == '2') {
                  statusIcon = Icons.pending;
                } else if (workOrder.status == '7') {
                  statusIcon = Icons.check;
                } else {
                  // If status is unknown, you can set a default icon or handle it accordingly
                  statusIcon = Icons.error;
                }

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Dismissible(
                      key: Key(workOrder.problem),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.archive,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) => _handleDismiss(workOrder),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkOrderTabView(),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.build),
                            ),
                            title: Text(
                              '${workOrder.problem}',
                              style: TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 12.0, overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,

                                // Add more text styles as needed
                              ),
                            ),
                            subtitle: Text(
                              '${workOrder.id}: ${workOrder.asset}',
                              style: TextStyle(
                                fontFamily: 'Vazir',

                                // Add more text styles as needed
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(workOrder.dueDate),
                                ),
                                SizedBox(width: 8.0),
                                Icon(
                                  statusIcon,
                                  color: Colors.deepOrange[
                                      100], // Set the desired icon color
                                ),
                              ],
                            ),
                            // Add more fields as needed
                          ),
                        ),
                      )),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _displayModalForm(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormScreen(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Asset {
  final int id;
  final String name;

  Asset({required this.id, required this.name});
}
