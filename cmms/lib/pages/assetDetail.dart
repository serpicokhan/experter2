import 'package:cmms/pages/assetview2.dart';
import 'package:flutter/material.dart';

import 'assetWorkOrder.dart';
import 'assetdetailview.dart';
import 'bomlistview.dart';
import 'linechart.dart';

class AssetDetailsView extends StatefulWidget {
  late final int assetId;
  AssetDetailsView({required this.assetId});
  @override
  _AssetDetailsViewState createState() => _AssetDetailsViewState();
}

class _AssetDetailsViewState extends State<AssetDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جزییات تجهیز',
          style: TextStyle(
            fontFamily: 'Vazir',
            fontSize: 16.0,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'جزییات',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 12.0,

                  // Add more text styles as needed
                ),
              ),
            ),
            Tab(
              child: Text(
                'BOM',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 12.0,

                  // Add more text styles as needed
                ),
              ),
            ),
            Tab(
              child: Text(
                'دستور کارها',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 12.0, overflow: TextOverflow.ellipsis,

                  // Add more text styles as needed
                ),
              ),
            ),
            Tab(
              child: Text(
                'قرائت',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 12.0, overflow: TextOverflow.ellipsis,

                  // Add more text styles as needed
                ),
              ),
            ),
            Tab(
              child: Text(
                'فایل',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 12.0, overflow: TextOverflow.ellipsis,

                  // Add more text styles as needed
                ),
              ),
            ),
            // Tab(text: 'فایل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AssetDetailView2(assetId: widget.assetId),
          PartsList(),
          WorkOrderList(),
          LineChartExample(),
          FilesView(),
        ],
      ),
    );
  }
}

class DetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Details View'),
    );
  }
}

class BOMView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('BOM View'),
    );
  }
}

class WorkOrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Work Orders View'),
    );
  }
}

class ReadingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Readings View'),
    );
  }
}

class FilesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Files View'),
    );
  }
}
