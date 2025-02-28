import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:user_maternityapp/weight.dart';

class WeightTrackingPage extends StatefulWidget {
  @override
  _WeightTrackingPageState createState() => _WeightTrackingPageState();
}

class _WeightTrackingPageState extends State<WeightTrackingPage> {
  List<FlSpot> weightData = [
    FlSpot(1, 60),
    FlSpot(2, 62),
    FlSpot(3, 65),
    FlSpot(4, 68),
  ];

  final List<Map<String, dynamic>> weightRecords = [
    {'date': '2024-01-10', 'weight': '60 kg'},
    {'date': '2024-02-05', 'weight': '62 kg'},
    {'date': '2024-03-15', 'weight': '65 kg'},
    {'date': '2024-04-20', 'weight': '68 kg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weight Tracker"), backgroundColor: Colors.pinkAccent),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weightData,
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: weightRecords.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        DateFormat('MMMM dd, yyyy').format(DateTime.parse(weightRecords[index]['date']!)),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Weight: ${weightRecords[index]['weight']}'),
                      leading: Icon(Icons.monitor_weight, color: Colors.pinkAccent),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text("Track your weight progress over time", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => WeightCheck()));
        },
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.monitor_weight_outlined),
      ),
    );
  }
}
