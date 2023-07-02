import 'package:cmms/pages/assetDetail.dart';
import 'package:cmms/pages/location.dart';
import 'package:cmms/pages/login.dart';
import 'package:cmms/pages/test.dart';
import 'package:cmms/pages/workorderapi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking login status
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            // User is logged in, navigate to the desired screen
            return BottomNavigation();
          } else {
            // User is not logged in, navigate to the login screen
            return LoginScreen();
          }
        }
      },
    );
  }
}

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
      home: AuthWrapper(),
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
    LoginDemo(),
    PlaceholderWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings'),
          // Add your settings UI here
        );
      },
    );
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
class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  late PageController _pageController;

  static const List<IconData> _icons = [
    Icons.work_outline,
    Icons.location_on_outlined,
    Icons.qr_code_outlined,
    Icons.settings_outlined,
  ];

  static const List<IconData> _filledIcons = [
    Icons.work,
    Icons.location_on,
    Icons.qr_code,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings'),
          // Add your settings UI here
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF296A52), // Darker green shade
              Color(0xFF58A68D), // Medium green shade
              Color(0xFFA4D4C7), // Light green shade
              Color(0xFFF1FAF7), // Very light tone
            ],
            stops: [
              0.0,
              0.4,
              0.8,
              1.0
            ], // Adjust the color stops for smooth transitions
          ),
        ),
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              WorkOrderListScreen(),
              LocationList(),
              LoginDemo(),
              PlaceholderWidget(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: _icons
                .asMap()
                .map(
                  (index, icon) => MapEntry(
                    index,
                    BottomNavigationBarItem(
                      icon: Icon(icon),
                      label: '',
                      activeIcon: Icon(_filledIcons[index]),
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}

class WorkOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          'Work Order Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Text(
          'Location Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        child: Text(
          'Scan Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
