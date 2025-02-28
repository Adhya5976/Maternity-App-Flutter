import 'package:flutter/material.dart';

class Weighttracker extends StatefulWidget {
  const Weighttracker({super.key});

  @override
  State<Weighttracker> createState() => _WeighttrackerState();
}

class _WeighttrackerState extends State<Weighttracker> {
 
  final List<Map<String, dynamic>> weightRecords = [
    {'week': 'Week 8', 'weight': '60 kg'},
    {'week': 'Week 16', 'weight': '62 kg'},
    {'week': 'Week 24', 'weight': '65 kg'},
    {'week': 'Week 32', 'weight': '68 kg'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracking'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: weightRecords.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                weightRecords[index]['week']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Weight: ${weightRecords[index]['weight']}'),
              leading: Icon(Icons.monitor_weight, color: Colors.pinkAccent),
            ),
          );
        },
      ),
    );
  }
}

