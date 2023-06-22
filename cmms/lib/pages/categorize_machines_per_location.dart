import 'dart:convert';

import 'package:cmms/pages/machinechartdata.dart';
import 'package:cmms/pages/machinlist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CategoryTabbedPage extends StatelessWidget {
  late final int assetId;
  late final int catId;
  CategoryTabbedPage({required this.assetId, required this.catId});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Tabs'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Assets'),
                Tab(text: 'Productions'),
                Tab(text: 'Broken Parts'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MachinList(assetId: this.assetId, catId: this.catId),
              ProductionsTab(
                assetId: this.assetId,
              ),
              BrokenPartsTab(),
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
      'http://192.168.2.60:8000/api/v1/Dashboard/' +
          loc.toString() +
          '/GetTolidBarAPI/'));
  print('http://192.168.2.60:8000/api/v1/Dashboard/' +
      loc.toString() +
      '/GetTolidBarAPI/');
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    Map<DateTime, double> data = {};
    for (var entry in jsonData['data']) {
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
