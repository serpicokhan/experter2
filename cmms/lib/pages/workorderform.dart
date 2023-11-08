import 'package:cmms/main.dart';
import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String input1Value = '';
  String input2Value = '';
  String input2id = '';
  String label = '';
  String seletedDate = '';
  TextEditingController input1Controller = TextEditingController();
  void initState() {
    super.initState();
    label = 'انتخاب تاریخ زمان';
    var a = DateTime.now();
    Gregorian g1 = Gregorian(a.year, a.month, a.day);
    Jalali j1 = g1.toJalali();
    int year = j1.year;
    int month = j1.month;
    int day = j1.day;
    setState(() {
      input1Controller.text = "$year/$month/$day";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form with Modal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onTap: () {
                showDateDialog(context);
              },
              controller: input1Controller,
              decoration: InputDecoration(labelText: 'Input 1'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _openModal(context);
              },
              child: TextFormField(
                enabled: false,
                controller: TextEditingController(text: input2Value),
                decoration: InputDecoration(
                  labelText: 'Input 2',
                  suffixIcon: Icon(Icons.edit),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveForm();
              },
              child: Text('Save Form'),
            ),
          ],
        ),
      ),
    );
  }

  void showDateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Choose Date'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearDatePicker(
              dateChangeListener: (String selectedDate) {
                setState(() {
                  input1Controller.text = selectedDate;
                });
              },
              showMonthName: true,
              isJalaali: true,
              labelStyle: TextStyle(
                fontFamily: 'Vazir',
                color: Colors.black,
              ),
              selectedRowStyle: TextStyle(
                fontFamily: 'Vazir',
                color: Colors.deepOrange,
              ),
              unselectedRowStyle: TextStyle(
                fontFamily: 'Vazir',
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _openModal(BuildContext context) async {
    final selectedAsset = await showModalBottomSheet<Location>(
      context: context,
      builder: (context) => YourModalWidget(),
    );

    if (selectedAsset != null) {
      setState(() {
        input2Value = '${selectedAsset.name} (ID: ${selectedAsset.id})';
        input2id = selectedAsset.id.toString();
      });
    }
  }

  void _showSnackBar(BuildContext context, String error) {
    final snackBar = SnackBar(
      content: Text(error),
      duration: Duration(
          seconds:
              3), // Set the duration for how long the SnackBar should be visible.
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          // Code to be executed when the 'Dismiss' action is pressed.
          // You can add any functionality here.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _saveForm() async {
    // Replace 'your_url' with the actual URL to which you want to post the data.
    // final url = Uri.parse(${MyGlobals.server}'/api/v1/RegMini/');
    DateTime currentDateTime = DateTime.now();

    final Map<String, dynamic> data = {
      'summaryofIssue': input1Value,
      'woAsset': input2id,
      'maintenanceType': 18,
      'woStatus': 1,
      // 'timecreated':
      //     '${currentDateTime.hour}:${currentDateTime.minute}:${currentDateTime.second}'
    };

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Read a string value
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse('${MyGlobals.server}/api/v1/RegMini/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode(data),
      );
      // final response = await http.post(url, body: json.encode(data));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful response here, if needed.
        // For example, show a success message or navigate to another page.

      } else {
        // Handle error response here, if needed.
        // For example, show an error message.
        _showSnackBar(
            context, 'خطایی به وجود آمده است' + response.statusCode.toString());
      }
    } catch (error) {
      // Handle exceptions here, if needed.
      // For example, show an error message.
      _showSnackBar(context, error.toString());
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomNavigation()));
  }
}

class YourModalWidget extends StatefulWidget {
  @override
  _YourModalWidgetState createState() => _YourModalWidgetState();
}

class Location {
  final String name;
  final String category;
  final int id;

  Location({required this.name, required this.id, required this.category});
}

class _YourModalWidgetState extends State<YourModalWidget> {
  TextEditingController searchController = TextEditingController();
  List<Location> locations = [];
  List<Location> filteredLocations = [];

  Future<void> fetchLocations() async {
    final url = '${MyGlobals.server}/api/v1/locations/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source);
      // final data = json.decode(response.body);
      final List<Location> fetchedLocations = [];

      for (var locationData in data) {
        final location = Location(
            name: locationData['assetName'],
            id: locationData['id'],
            category: locationData['assetCategory']['name']);

        fetchedLocations.add(location);
      }

      setState(() {
        locations = fetchedLocations;
        filteredLocations =
            fetchedLocations; // Initialize filteredLocations with all locations initially
      });
    } else {
      // Handle API error
      print('Error fetching locations: ${response.statusCode}');
    }
  }

  void filterLocations(String query) {
    setState(() {
      filteredLocations = locations
          .where((location) =>
              location.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  void _onIconTapped(Location asset) {
    // Custom action when the icon is tapped
    print('Icon tapped: ${asset.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: searchController,
            onChanged: (value) {
              filterLocations(value);
            },
            decoration: InputDecoration(
              labelText: 'Search Assets',
              suffixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                  itemCount: filteredLocations.length,
                  itemBuilder: (context, index) {
                    Location asset = filteredLocations[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context, asset);
                      },
                      title: Text(asset.name),
                      subtitle: Text('ID: ${asset.id}'),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
