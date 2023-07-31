import 'package:cmms/main.dart';
import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String input1Value = '';
  String input2Value = '';
  String input2id = '';

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
              onChanged: (value) {
                setState(() {
                  input1Value = value;
                });
              },
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

  void _openModal(BuildContext context) async {
    final selectedAsset = await showModalBottomSheet<AssetData>(
      context: context,
      builder: (context) => YourModalWidget(),
    );

    if (selectedAsset != null) {
      setState(() {
        input2Value = '${selectedAsset.name} (ID: ${selectedAsset.id})';
        input2id = selectedAsset.id;
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

class _YourModalWidgetState extends State<YourModalWidget> {
  TextEditingController searchController = TextEditingController();
  List<AssetData> allAssets = [
    AssetData(id: '6936', name: 'Asset 1'),
    AssetData(id: '6942', name: 'Asset 2'),
    AssetData(id: '6961', name: 'Asset 3'),
    // Add more assets as needed
  ];

  List<AssetData> filteredAssets = [];

  @override
  void initState() {
    super.initState();
    filteredAssets.addAll(allAssets);
  }

  void _filterAssets(String query) {
    filteredAssets.clear();
    filteredAssets.addAll(allAssets.where((asset) =>
        asset.name.toLowerCase().contains(query.toLowerCase()) ||
        asset.id.toLowerCase().contains(query.toLowerCase())));
    setState(() {});
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
              _filterAssets(value);
            },
            decoration: InputDecoration(
              labelText: 'Search Assets',
              suffixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAssets.length,
              itemBuilder: (context, index) {
                AssetData asset = filteredAssets[index];
                return ListTile(
                  onTap: () {
                    Navigator.pop(context, asset);
                  },
                  title: Text(asset.name),
                  subtitle: Text('ID: ${asset.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AssetData {
  final String id;
  final String name;

  AssetData({required this.id, required this.name});
}
