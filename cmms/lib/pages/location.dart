import 'dart:convert';
import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'assetDetail.dart';

class LocationList extends StatefulWidget {
  @override
  _LocationListState createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  List<Location> locations = [];
  List<Location> filteredLocations = [];

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

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
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return CircularProgressIndicator(); // Show loading indicator while fetching data
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => filterLocations(value),
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredLocations.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text(
                    filteredLocations[index].name,
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    filteredLocations[index].category.toString(),
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
                                assetId: filteredLocations[index].id,
                                assetName: filteredLocations[index].name,
                              )),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
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

// Location model class
class Location {
  final String name;
  final String category;
  final int id;

  Location({required this.name, required this.id, required this.category});
}
