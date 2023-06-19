import 'package:cmms/pages/assetDetail.dart';
import 'package:cmms/pages/location.dart';
import 'package:cmms/pages/login.dart';
import 'package:cmms/pages/workorderapi.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LocationListView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    WorkOrderListScreen(),
    LocationList(),
    LoginPage(),
    PlaceholderWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Locations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'تجهیز',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

// class LocationList2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: locations.length,
//       itemBuilder: (BuildContext context, int index) {
//         return ListTile(
//           title: Text(locations[index].name),
//           subtitle: Text(locations[index].description),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.info_outline),
//               SizedBox(width: 4.0),
//               Container(
//                 padding: EdgeInsets.all(4.0),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Text(
//                   '5', // Replace with your batch counter value
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           onTap: () {
//             // Handle location item tap
//             // You can navigate to asset list or perform any desired action here
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AssetDetailsView()),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class PlaceholderWidget extends StatelessWidget {
//   PlaceholderWidget();

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// // Location model class
// class Location {
//   final String name;
//   final String description;

//   Location({required this.name, required this.description});
// }

// // Sample list of locations
// List<Location> locations = [
//   Location(name: 'Location 1', description: 'Description 1'),
//   Location(name: 'Location 2', description: 'Description 2'),
//   Location(name: 'Location 3', description: 'Description 3'),
//   // Add more locations as needed
// ];
