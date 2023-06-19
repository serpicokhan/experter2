import 'package:flutter/material.dart';

class AssetDetailView extends StatefulWidget {
  @override
  _AssetDetailViewState createState() => _AssetDetailViewState();
}

class _AssetDetailViewState extends State<AssetDetailView> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/asset_image.jpg'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Perform action on button press
                  },
                  child: Text('Button'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Asset Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Perform action on field click
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Asset Code',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.circle,
                    color: isOnline ? Colors.green : Colors.red, size: 12.0),
                SizedBox(width: 8.0),
                Text('Online', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Switch(
                    value: isOnline,
                    onChanged: (value) {
                      setState(() {
                        isOnline = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Perform action on field click
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parent Asset:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Parent Asset Name'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Perform action on field click
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subasset Count:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('5'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Perform action on field click
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Asset Location'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Perform action on field click
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Asset Category'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Perform action on field click
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manufacturer:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Asset Manufacturer'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Perform action on field click
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model/Serial No:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Asset Model/Serial No'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Perform action on field click
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Asset Description'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
