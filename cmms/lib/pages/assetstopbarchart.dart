import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Model class for your data
class DataPoint {
  final String category;
  final int value;

  DataPoint(this.category, this.value);
}

class BarChartPage extends StatefulWidget {
  late final int assetId;
  BarChartPage({required this.assetId});
  @override
  _BarChartPageState createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  List<charts.Series<DataPoint, String>> seriesList = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from the API when the page loads
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://192.168.2.60:8000/api/v1/Asset/${widget.assetId}/StopCount/'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<DataPoint> dataPoints = [];

      for (var item in jsonData) {
        dataPoints.add(DataPoint(item['value'], item['date']));
      }

      setState(() {
        seriesList = [
          charts.Series<DataPoint, String>(
            id: 'data',
            data: dataPoints,
            domainFn: (DataPoint data, _) => data.category,
            measureFn: (DataPoint data, _) => data.value,
          ),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300, // Adjust the height as per your needs
          padding: EdgeInsets.all(16.0),
          child: charts.BarChart(
            seriesList,
            animate: true,
            domainAxis: charts.OrdinalAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.black,
                  fontFamily: 'Vazir', // Set the desired font family
                  fontSize: 12, // Set the desired font size
                ),
              ),
            ),
            defaultRenderer: charts.BarRendererConfig(
              // Configure the renderer to have diagonal bars
              cornerStrategy: const charts.ConstCornerStrategy(30),
            ),
          ),
        ),
      ),
    );
  }
}
