// import 'package:flutter/material.dart';

// class PartsList extends StatefulWidget {
//   @override
//   _PartsListState createState() => _PartsListState();
// }

// class _PartsListState extends State<PartsList> {
//   List<String> parts = [
//     'Part 1',
//     'Part 2',
//     'Part 3',
//     'Part 4',
//     'Part 5',
//     'Part 6',
//     'Part 7',
//     'Part 8',
//     'Part 9',
//     'Part 10',
//   ];
//   String searchTerm = '';

//   @override
//   Widget build(BuildContext context) {
//     List<String> filteredParts = parts.where((part) {
//       final lowerCaseTerm = searchTerm.toLowerCase();
//       return part.toLowerCase().contains(lowerCaseTerm);
//     }).toList();

//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   searchTerm = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.separated(
//               itemCount: filteredParts.length,
//               separatorBuilder: (BuildContext context, int index) => Divider(),
//               itemBuilder: (BuildContext context, int index) {
//                 final part = filteredParts[index];
//                 return ListTile(
//                   title: Text(
//                     part,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   trailing: Text('Count: ${index + 1}'),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PartsList extends StatefulWidget {
  late final int assetId;
  PartsList({required this.assetId});
  @override
  _PartsListState createState() => _PartsListState();
}

class _PartsListState extends State<PartsList> {
  List<Part> parts = [];
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    fetchParts(); // Fetch parts data when the widget is initialized
  }

  Future<void> fetchParts() async {
    final response = await http.get(Uri.parse(
        '${MyGlobals.server}/api/v1/AssetPart/${widget.assetId}/listAssetPart/'));
    if (response.statusCode == 200) {
      // final jsonData = json.decode(response.body);
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final jsonData = jsonDecode(source);
      setState(() {
        parts =
            jsonData.map<Part>((partJson) => Part.fromJson(partJson)).toList();
      });
    } else {
      throw Exception('Failed to fetch parts');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Part> filteredParts = parts.where((part) {
      final lowerCaseTerm = searchTerm.toLowerCase();
      return part.name.toLowerCase().contains(lowerCaseTerm) ||
          part.code.toLowerCase().contains(lowerCaseTerm) ||
          part.id.toString().contains(lowerCaseTerm) ||
          part.qty.toString().contains(lowerCaseTerm);
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
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    title: Text(
                      part.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Code: ${part.code}',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                        Text(
                          'ID: ${part.id.toString()}',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                        Text(
                          'Qty: ${part.qty.toString()}',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
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

class Part {
  final String name;
  final String code;
  final int id;
  final int qty;

  Part({
    required this.name,
    required this.code,
    required this.id,
    required this.qty,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      name: json['BOMGroupPartPart']['partName'],
      code: json['BOMGroupPartPart']['partCode'],
      id: json['BOMGroupPartPart']['id'],
      qty: json['BOMGroupPartQnty'],
    );
  }
}
