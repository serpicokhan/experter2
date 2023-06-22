// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class MachineCategory {
//   final String name;
//   final int badgeNumber;
//   final int id;
//   final IconData icon;

//   MachineCategory(
//       {required this.id,
//       required this.name,
//       required this.badgeNumber,
//       required this.icon});
// }

// class MachineCategoryPage extends StatefulWidget {
//   late final int assetId;
//   MachineCategoryPage({required this.assetId});
//   @override
//   _MachineCategoryPageState createState() => _MachineCategoryPageState();
// }

// class _MachineCategoryPageState extends State<MachineCategoryPage> {
//   List<MachineCategory> categories = [];

//   Future<List<MachineCategory>> fetchMachineCategories() async {
//     // Replace the URL with your API endpoint
//     final response = await http.get(Uri.parse(
//         'http://192.168.2.60:8000/api/v1/Asset/${widget.assetId}/Categories/'));

//     if (response.statusCode == 200) {
//       String source = const Utf8Decoder().convert(response.bodyBytes);
//       final data = jsonDecode(source) as List<dynamic>;
//       // final data = json.decode(response.body) as List<dynamic>;
//       return data.map((category) {
//         return MachineCategory(
//           id: category['id'],
//           name: category['name'],
//           badgeNumber: category['asset_count'],
//           icon: Icons.category,
//         );
//       }).toList();
//     } else {
//       throw Exception('Failed to fetch machine categories');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchMachineCategories().then((fetchedCategories) {
//       setState(() {
//         categories = fetchedCategories;
//       });
//     }).catchError((error) {
//       print('Error: $error');
//       // Handle error state
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Machine Categories'),
//       ),
//       body: categories.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     // Handle card click event here
//                     print('Clicked ${categories[index].name}');
//                   },
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         children: [
//                           Icon(categories[index].icon),
//                           SizedBox(width: 16.0),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   categories[index].name,
//                                   style: TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(height: 4.0),
//                                 Text(
//                                   'Badge: ${categories[index].badgeNumber}',
//                                   style: TextStyle(fontSize: 14.0),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Icon(Icons.arrow_forward_ios),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'dart:convert';
import 'package:cmms/pages/categorize_machines_per_location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MachineCategory {
  final String name;
  final int badgeNumber;
  final int id;
  final IconData icon;

  MachineCategory(
      {required this.id,
      required this.name,
      required this.badgeNumber,
      required this.icon});
}

class MachineCategoryPage extends StatefulWidget {
  late final int assetId;
  MachineCategoryPage({required this.assetId});
  @override
  _MachineCategoryPageState createState() => _MachineCategoryPageState();
}

class _MachineCategoryPageState extends State<MachineCategoryPage> {
  List<MachineCategory> categories = [];

  Future<List<MachineCategory>> fetchMachineCategories() async {
    // Replace the URL with your API endpoint
    final response = await http.get(Uri.parse(
        'http://192.168.2.60:8000/api/v1/Asset/${widget.assetId}/Categories/'));

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source) as List<dynamic>;
      // final data = json.decode(response.body) as List<dynamic>;
      return data.map((category) {
        return MachineCategory(
          id: category['id'],
          name: category['name'],
          badgeNumber: category['asset_count'],
          icon: Icons.category,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch machine categories');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMachineCategories().then((fetchedCategories) {
      setState(() {
        categories = fetchedCategories;
      });
    }).catchError((error) {
      print('Error: $error');
      // Handle error state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Categories'),
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Handle card click event here
                    // print('Clicked ${categories[index].name}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryTabbedPage(
                                assetId: widget.assetId,
                                catId: categories[index].id,
                              )),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(categories[index].icon),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categories[index].name,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Vazir',
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Badge: ${categories[index].badgeNumber}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
