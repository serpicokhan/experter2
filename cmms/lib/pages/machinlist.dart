import 'dart:convert';
import 'package:cmms/pages/assetDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MachinList extends StatefulWidget {
  late final int assetId;
  MachinList({required this.assetId});
  @override
  _MachinListState createState() => _MachinListState();
}

class _MachinListState extends State<MachinList> {
  List<MachinClass> Machins = [];
  List<MachinClass> filteredMachins = [];

  @override
  void initState() {
    super.initState();
    fetchMachins();
  }

  Future<void> fetchMachins() async {
    final url = 'http://192.168.2.60:8000/api/v1/${widget.assetId}/Machines/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source);
      // final data = json.decode(response.body);
      final List<MachinClass> fetchedMachins = [];

      for (var MachinData in data) {
        final machinClass = MachinClass(
          name: MachinData['assetName'],
          id: MachinData['id'],
          category: MachinData['assetCategory']['name'],
        );
        fetchedMachins.add(machinClass);
      }

      setState(() {
        Machins = fetchedMachins;
        filteredMachins =
            fetchedMachins; // Initialize filteredMachins with all Machins initially
      });
    } else {
      // Handle API error
      print('Error fetching Machins: ${response.statusCode}');
    }
  }

  void filterMachins(String query) {
    setState(() {
      filteredMachins = Machins.where((Machin) =>
          Machin.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Machins.isEmpty) {
      return CircularProgressIndicator(); // Show loading indicator while fetching data
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ماشین آلات',
          style: TextStyle(fontFamily: 'Vazir'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredMachins.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.account_tree),
                    title: Text(
                      filteredMachins[index].name,
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Text(
                      filteredMachins[index].category.toString(),
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 16.0,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 4.0),
                        Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            '5', // Replace with your batch counter value
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Vazir',
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle location item tap
                      // You can navigate to asset list or perform any desired action here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssetDetailsView(
                                assetId: filteredMachins[index].id)),
                      );
                    },
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

class PlaceholderWidget extends StatelessWidget {
  PlaceholderWidget();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Machin model class
class MachinClass {
  final String name;
  final String category;
  final int id;

  MachinClass({required this.name, required this.id, required this.category});
}
