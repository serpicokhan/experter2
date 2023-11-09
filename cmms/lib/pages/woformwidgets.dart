import 'dart:convert';
import 'dart:io';

import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YourModalWidget extends StatefulWidget {
  @override
  _YourModalWidgetState createState() => _YourModalWidgetState();
}

class UserModalWidget extends StatefulWidget {
  @override
  _UserModalWidgetState createState() => _UserModalWidgetState();
}

class Location {
  final String name;
  final String category;
  final int id;

  Location({required this.name, required this.id, required this.category});
}

// create dart class according to this fileds fields = ('id', 'fullName','title','email','userId')
class SysUser {
  final String fullName;
  final String title;
  final String email;
  final int id;
  final int userId;

  SysUser(
      {required this.fullName,
      required this.id,
      required this.title,
      required this.email,
      required this.userId});
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

class _UserModalWidgetState extends State<UserModalWidget> {
  TextEditingController searchController = TextEditingController();
  List<SysUser> locations = [];
  List<SysUser> filteredLocations = [];

  Future<void> fetchLocations() async {
    final url = '${MyGlobals.server}/api/v1/Users/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source);
      // final data = json.decode(response.body);
      final List<SysUser> fetchedLocations = [];

      for (var locationData in data) {
        final location = SysUser(
          fullName: locationData['fullName'],
          id: locationData['id'],
          email: locationData['email'] ?? '',
          title: locationData['title'],
          userId: locationData['userId'],
        );

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
              location.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  void _onIconTapped(SysUser asset) {
    // Custom action when the icon is tapped
    print('Icon tapped: ${asset.fullName}');
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
                    SysUser asset = filteredLocations[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context, asset);
                      },
                      title: Text(asset.fullName),
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

class LargeImageDialog extends StatelessWidget {
  final File image;

  LargeImageDialog(this.image);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300, // Set the width to your desired size
        height: 300, // Set the height to your desired size
        child: Image.file(image),
      ),
    );
  }
}
