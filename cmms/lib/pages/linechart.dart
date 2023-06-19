import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineChartExample extends StatefulWidget {
  @override
  _LineChartExampleState createState() => _LineChartExampleState();
}

class _LineChartExampleState extends State<LineChartExample> {
  late List<charts.Series<TimeSeriesData, DateTime>> seriesList;
  late bool animate;
  late double minDomain;
  late double maxDomain;

  @override
  void initState() {
    super.initState();
    seriesList = _createSampleData();
    animate = false;
    minDomain = 0.0;
    maxDomain = seriesList[0].data.length.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (details) {
          setState(() {
            final chartWidth = MediaQuery.of(context).size.width -
                16.0 * 2; // Subtract padding
            final dataLength = seriesList[0].data.length;
            final dragDistance = details.primaryDelta ?? 0.0;
            final dragRatio = dragDistance / chartWidth;
            final domainDelta = dragRatio * dataLength;
            minDomain = (minDomain + domainDelta)
                .clamp(0.0, dataLength.toDouble() - 1.0);
            maxDomain =
                (maxDomain + domainDelta).clamp(1.0, dataLength.toDouble());
          });
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: charts.TimeSeriesChart(
            seriesList,
            animate: animate,
            primaryMeasureAxis:
                charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
            domainAxis: charts.DateTimeAxisSpec(
              viewport: charts.DateTimeExtents(
                start: seriesList[0].data[minDomain.toInt()].time,
                end: seriesList[0].data[maxDomain.toInt() - 1].time,
              ),
              tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                day: charts.TimeFormatterSpec(
                  format: 'd',
                  transitionFormat: 'MM/dd/yyyy',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<charts.Series<TimeSeriesData, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesData(DateTime(2023, 6, 1), 5),
      TimeSeriesData(DateTime(2023, 6, 2), 10),
      TimeSeriesData(DateTime(2023, 6, 3), 7),
      TimeSeriesData(DateTime(2023, 6, 4), 12),
      TimeSeriesData(DateTime(2023, 6, 5), 9),
      TimeSeriesData(DateTime(2023, 6, 6), 15),
      TimeSeriesData(DateTime(2023, 6, 7), 11),
      TimeSeriesData(DateTime(2023, 6, 8), 13),
      TimeSeriesData(DateTime(2023, 6, 9), 8),
      TimeSeriesData(DateTime(2023, 6, 10), 14),
      TimeSeriesData(DateTime(2023, 6, 11), 5),
      TimeSeriesData(DateTime(2023, 6, 12), 10),
      TimeSeriesData(DateTime(2023, 6, 13), 7),
      TimeSeriesData(DateTime(2023, 6, 14), 12),
      TimeSeriesData(DateTime(2023, 6, 15), 9),
      TimeSeriesData(DateTime(2023, 6, 16), 15),
      TimeSeriesData(DateTime(2023, 6, 17), 11),
      TimeSeriesData(DateTime(2023, 6, 18), 13),
      TimeSeriesData(DateTime(2023, 6, 19), 8),
      TimeSeriesData(DateTime(2023, 6, 20), 14),
    ];

    return [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'SampleData',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: data,
      ),
    ];
  }
}

class TimeSeriesData {
  final DateTime time;
  final int value;

  TimeSeriesData(this.time, this.value);
}
