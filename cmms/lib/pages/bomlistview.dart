import 'package:flutter/material.dart';

class PartsList extends StatefulWidget {
  @override
  _PartsListState createState() => _PartsListState();
}

class _PartsListState extends State<PartsList> {
  List<String> parts = [
    'Part 1',
    'Part 2',
    'Part 3',
    'Part 4',
    'Part 5',
    'Part 6',
    'Part 7',
    'Part 8',
    'Part 9',
    'Part 10',
  ];
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    List<String> filteredParts = parts.where((part) {
      final lowerCaseTerm = searchTerm.toLowerCase();
      return part.toLowerCase().contains(lowerCaseTerm);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
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
          Expanded(
            child: ListView.separated(
              itemCount: filteredParts.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                final part = filteredParts[index];
                return ListTile(
                  title: Text(
                    part,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text('Count: ${index + 1}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
