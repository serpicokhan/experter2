// import 'package:flutter/material.dart';

// class CategoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Category Page'),
//       ),
//       body: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             leading: Icon(Icons.category), // Replace with category icon
//             title: Text('Category $index'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.info_outline),
//                 SizedBox(width: 4.0),
//                 Container(
//                   padding: EdgeInsets.all(4.0),
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Text(
//                     '5', // Replace with your batch counter value
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             onTap: () {
//               // Handle tile tap
//               // You can navigate to a detail page or perform any desired action here
//               print('Tile $index tapped');
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MachineCategory {
  final String name;
  final int badgeNumber;
  final IconData icon;

  MachineCategory(
      {required this.name, required this.badgeNumber, required this.icon});
}

class MachineCategoryPage extends StatelessWidget {
  final List<MachineCategory> categories = [
    MachineCategory(name: 'Category 1', badgeNumber: 5, icon: Icons.category),
    MachineCategory(name: 'Category 2', badgeNumber: 8, icon: Icons.category),
    MachineCategory(name: 'Category 3', badgeNumber: 3, icon: Icons.category),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle card click event here
              print('Clicked ${categories[index].name}');
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(categories[index].icon),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categories[index].name,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Badge: ${categories[index].badgeNumber}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
