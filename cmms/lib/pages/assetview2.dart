// import 'package:flutter/material.dart';

// class AssetDetailView2 extends StatefulWidget {
//   @override
//   _AssetDetailViewState createState() => _AssetDetailViewState();
// }

// class _AssetDetailViewState extends State<AssetDetailView2> {
//   bool isOnline = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Image.asset('assets/asset_image.jpg'),
//             SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Perform action on button press
//                   },
//                   child: Text('Button'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             Align(
//               alignment: Alignment.center,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Asset Name',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   InkWell(
//                     onTap: () {
//                       // Perform action on field click
//                     },
//                     child: Text(
//                       'Asset Code',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 14.0,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             SizedBox(height: 16.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.circle,
//                               color: isOnline ? Colors.green : Colors.red,
//                               size: 12.0),
//                           SizedBox(width: 8.0),
//                           Text('Online',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       SizedBox(height: 8.0),
//                       Text('Status description'),
//                     ],
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Switch(
//                     value: isOnline,
//                     onChanged: (value) {
//                       setState(() {
//                         isOnline = value;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 // Perform action on field click
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Parent Asset:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('Parent Asset Name'),
//                   SizedBox(height: 16.0),
//                 ],
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 // Perform action on field click
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Subasset Count:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('5'),
//                   SizedBox(height: 16.0),
//                 ],
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 // Perform action on field click
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Location:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('Asset Location'),
//                   SizedBox(height: 16.0),
//                 ],
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 // Perform action on field click
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Category:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('Asset Category'),
//                   SizedBox(height: 16.0),
//                 ],
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 // Perform action on field click
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Manufacturer:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('Asset Manufacturer'),
//                   SizedBox(height: 16.0),
//                 ],
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 // Perform action on field click
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Model/Serial No:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('Asset Model/Serial No'),
//                   SizedBox(height: 16.0),
//                 ],
//               ),
//             ),
//             Divider(),
//             InkWell(
//               onTap: () {
//                 // Perform action on field click
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Description:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('Asset Description'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//**************************************
// */
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AssetDetailView2 extends StatefulWidget {
  late final int assetId;
  AssetDetailView2({required this.assetId});
  @override
  _AssetDetailViewState createState() => _AssetDetailViewState();
}

class _AssetDetailViewState extends State<AssetDetailView2> {
  Map<String, dynamic>? assetData;

  @override
  void initState() {
    super.initState();
    fetchAssetData();
  }

  Future<void> fetchAssetData() async {
    // widget.assetId
    final url =
        'http://192.168.2.60:8000/api/v1/locations/${widget.assetId}/Details';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(source);
      setState(() {
        assetData = data;
      });
    } else {
      // Handle API error
      print('Error fetching asset data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (assetData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image.asset('assets/asset_image.jpg'),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //   ElevatedButton(
                  //     onPressed: () {
                  //       // Perform action on button press
                  //     },
                  //     child: Text('Button'),
                  //   ),
                ],
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      assetData!['assetName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Vazir',
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    InkWell(
                      onTap: () {
                        // Perform action on field click
                      },
                      child: Text(
                        assetData!['assetCode'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle,
                                color: assetData!['assetStatus']
                                    ? Colors.green
                                    : Colors.red,
                                size: 12.0),
                            SizedBox(width: 8.0),
                            Text('آنلاین',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Vazir')),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        // Text(assetData!['assetDescription']),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Switch(
                      value: assetData!['assetStatus'],
                      onChanged: (value) {
                        setState(() {
                          assetData!['assetStatus'] = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Divider(),

              Divider(),
              InkWell(
                onTap: () {
                  // Perform action on field click
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'ماشین آلات',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Vazir'),
                    ),
                    Text(assetData!['sub_asset_count'].toString()),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  // Perform action on field click
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'مکان:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Vazir'),
                    ),
                    Text(
                      assetData!['assetIsLocatedAt'] ?? 'ندارد',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  // Perform action on field click
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'دسته بندی',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      assetData!['assetCategory']['name'].toString() ??
                          'نامشخص',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  // Perform action on field click
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'سازنده:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      assetData!['assetManufacture'] ?? 'نامشخص',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  // Perform action on field click
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'مدل/سریال نامبر',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      assetData!['assetModel'] ?? 'نامشخص',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  // Perform action on field click
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'شرح:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      assetData!['assetDescription'] ?? 'نامشخص',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
