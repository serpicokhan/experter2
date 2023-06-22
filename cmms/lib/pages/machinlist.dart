import 'dart:convert';
import 'package:cmms/pages/assetDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MachinList extends StatefulWidget {
  late final int assetId;
  late final int catId;
  MachinList({required this.assetId, required this.catId});
  @override
  _MachinListState createState() => _MachinListState();
}

class _MachinListState extends State<MachinList> {
  List<MachinClass> Machins = [];
  List<MachinClass> filteredMachins = [];
  List<String> categories = []; // Added categories list
  List<String> selectedCategories = []; // Added selectedCategories list

  @override
  void initState() {
    super.initState();
    fetchMachins();
  }

  Future<void> fetchMachins() async {
    final url =
        'http://192.168.2.60:8000/api/v1/${widget.assetId}/${widget.catId}/Machines/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source);
      final List<MachinClass> fetchedMachins = [];
      final List<String> fetchedCategories = [];

      for (var MachinData in data) {
        final machinClass = MachinClass(
          name: MachinData['assetName'],
          id: MachinData['id'],
          category: MachinData['assetCategory']['name'],
        );
        fetchedMachins.add(machinClass);

        if (!fetchedCategories.contains(MachinData['assetCategory']['name'])) {
          fetchedCategories.add(MachinData['assetCategory']['name']);
        }
      }

      setState(() {
        Machins = fetchedMachins;
        filteredMachins = fetchedMachins;
        categories = fetchedCategories;
      });
    } else {
      print('Error fetching Machins: ${response.statusCode}');
    }
  }

  void filterMachins(String query) {
    setState(() {
      filteredMachins = Machins.where((Machin) =>
          Machin.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }

      filteredMachins = Machins.where(
          (Machin) => selectedCategories.contains(Machin.category)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Machins.isEmpty) {
      return CircularProgressIndicator();
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
          Wrap(
            spacing: 8.0,
            children: categories.map((category) {
              final isSelected = selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (isSelected) {
                  toggleCategory(category);
                },
                selectedColor: Colors.blue,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
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
                      filteredMachins[index].category,
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
                            '5',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssetDetailsView(
                            assetId: filteredMachins[index].id,
                          ),
                        ),
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

class MachinClass {
  final String name;
  final String category;
  final int id;

  MachinClass({required this.name, required this.id, required this.category});
}
