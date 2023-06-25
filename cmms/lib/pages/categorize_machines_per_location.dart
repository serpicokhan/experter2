import 'dart:convert';

import 'package:cmms/pages/assetcategory.dart';
import 'package:cmms/pages/assetstopbarchart.dart';
import 'package:cmms/pages/machinechartdata.dart';
import 'package:cmms/pages/machinlist.dart';
import 'package:cmms/util/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CategoryTabbedPage extends StatelessWidget {
  late final int assetId;
  late final int catId;
  late final String assetName;
  // MachineCategoryPage x;
  CategoryTabbedPage(
      {required this.assetId, required this.catId, required this.assetName});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              this.assetName,
              style: TextStyle(fontFamily: 'Vazir'),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'تجهیزات',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                ),
                Tab(
                  child: Text(
                    'تولید',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                ),
                Tab(
                  child: Text(
                    'توقفات',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MachinList(assetId: this.assetId, catId: this.catId),
              ProductionsTab(
                assetId: this.assetId,
              ),
              BarChartPage(
                assetId: this.assetId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssetsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Assets Tab',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

Future<Map<DateTime, double>> fetchDataFromAPI(int loc) async {
  final response = await http.get(Uri.parse(
      '${MyGlobals.server}/api/v1/Dashboard/' +
          loc.toString() +
          '/GetTolidBarAPI/'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    Map<DateTime, double> data = {};
    for (var entry in jsonData) {
      DateTime date = DateFormat("yyyy-MM-dd").parse(entry['date']);
      double value = double.parse(entry['value']);
      data[date] = value;
    }
    return data;
  } else {
    throw Exception('Failed to fetch data from API');
  }
}

class ProductionsTab extends StatelessWidget {
  final int assetId;
  ProductionsTab({required this.assetId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, double>>(
      future: fetchDataFromAPI(this.assetId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(
            child: LineChartWidget(data: snapshot.data!),
          );
        }
      },
    );
  }
}

class BrokenPartsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Broken Parts Tab',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
