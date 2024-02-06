import 'package:flutter/material.dart';

class Part {
  final String name;
  final String partNumber;
  final IconData icon;
  final int quantity;

  Part({
    required this.name,
    required this.partNumber,
    required this.icon,
    required this.quantity,
  });
}

class PartsListScreen extends StatelessWidget {
  final List<Part> parts = [
    Part(
      name: 'Part 1',
      partNumber: '12345',
      icon: Icons.build,
      quantity: 10,
    ),
    Part(
      name: 'Part 2',
      partNumber: '67890',
      icon: Icons.build,
      quantity: 20,
    ),
    // Add more parts here as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: parts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(parts[index].icon),
              title: Text(parts[index].name),
              subtitle: Text(
                'Part Number: ${parts[index].partNumber}\n'
                'Quantity: ${parts[index].quantity}',
              ),
            ),
          );
        },
      ),
    );
  }
}
