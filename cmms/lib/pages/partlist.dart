import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Part {
  final int id;
  final String PartQty;

  final String description;

  Part({required this.id, required this.description, required this.PartQty});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['id'],
      PartQty: json['woPartPlannedQnty'].toString(),
      description: json['woPartStock']['stockItem']['partName'] ?? '',
    );
  }
}

class PartView extends StatefulWidget {
  final int workOrderId;

  PartView({Key? key, required this.workOrderId}) : super(key: key);

  @override
  _PartViewState createState() => _PartViewState();
}

class _PartViewState extends State<PartView> {
  List<Part> _Parts = [];

  @override
  void initState() {
    super.initState();
    _fetchParts(widget.workOrderId);
  }

  Future<void> _fetchParts(int workOrderId) async {
    // Replace the URL with your actual endpoint that returns Parts for a given workOrderId
    final response = await http.get(Uri.parse(
        '${MyGlobals.server}/api/v1/WorkOrder/${widget.workOrderId}/Parts'));

    if (response.statusCode == 200) {
      List<dynamic> PartsJson = json.decode(response.body);
      setState(() {
        _Parts = PartsJson.map((json) => Part.fromJson(json)).toList();
      });
    } else {
      // Handle error
      print('Failed to load Parts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: _Parts.length,
          itemBuilder: (context, index) {
            Part part = _Parts[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.task, color: Colors.deepPurple),
                title: Text(
                  part.description,
                  style: TextStyle(
                    fontFamily: 'Vazir', // Specify your custom font
                    fontSize: 18.0, // Adjust the size as needed
                  ),
                ),
                subtitle: Text(
                  part.PartQty,
                  style: TextStyle(
                    fontFamily: 'Vazir', // Specify your custom font
                    fontSize: 14.0, // Adjust the size as needed
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
