import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineChartWidget extends StatelessWidget {
  final Map<DateTime, double> data;

  LineChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartData, DateTime>> seriesList = [
      charts.Series(
        id: 'LineChart',
        data: data.entries
            .map((entry) => ChartData(entry.key, entry.value))
            .toList(),
        domainFn: (ChartData chartData, _) => chartData.date,
        measureFn: (ChartData chartData, _) => chartData.value,
      ),
    ];

    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
    );
  }
}

class ChartData {
  final DateTime date;
  final double value;

  ChartData(this.date, this.value);
}
