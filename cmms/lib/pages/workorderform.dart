import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkOrderFormPage extends StatefulWidget {
  @override
  _WorkOrderFormPageState createState() => _WorkOrderFormPageState();
}

class _WorkOrderFormPageState extends State<WorkOrderFormPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _problemController = TextEditingController();
  TextEditingController _assetController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  TextEditingController _maintenanceTypeController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();

  Future<void> _sendWorkOrder() async {
    if (_formKey.currentState!.validate()) {
      final url = 'http://192.168.2.60:8000/api/v1/wos2/';

      final response = await http.post(
        Uri.parse(url),
        body: {
          'problem': _problemController.text,
          'asset': _assetController.text,
          'dueDate': _dueDateController.text,
          'maintenanceType': _maintenanceTypeController.text,
          'status': _statusController.text,
          'priority': _priorityController.text,
        },
      );

      if (response.statusCode == 200) {
        // API call successful
        final data = jsonDecode(response.body);
        // Handle the response data as needed
      } else {
        // API call failed
        // Handle the error
      }
    }
  }

  Future<void> _showAssetSelectionDialog() async {
    String? selectedAsset;

    List<String> assetList = ['Asset 1', 'Asset 2', 'Asset 3', 'Asset 4'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Asset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  // Perform search logic here
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: assetList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(assetList[index]),
                      onTap: () {
                        setState(() {
                          selectedAsset = assetList[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    ).then((value) {
      // Update the asset field with the selected asset
      if (selectedAsset != null) {
        setState(() {
          _assetController.text = selectedAsset!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Order Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _problemController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a problem';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Problem',
                ),
              ),
              GestureDetector(
                onTap: _showAssetSelectionDialog,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _assetController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an asset';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Asset',
                    ),
                  ),
                ),
              ),
              // Add more form fields as needed

              ElevatedButton(
                onPressed: _sendWorkOrder,
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
