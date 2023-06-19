import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastResultsPage extends StatefulWidget {
  @override
  _PastResultsPageState createState() => _PastResultsPageState();
}

class _PastResultsPageState extends State<PastResultsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<BMIResult> bmiResults = [];

  @override
  void initState() {
    super.initState();
    fetchBMIResults();
  }

  void fetchBMIResults() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      QuerySnapshot snapshot = await firestore
          .collection('bmiResults')
          .where('userId', isEqualTo: userId)
          .get();

      List<BMIResult> results = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        final bmi = data['bmi'] as double;
        return BMIResult(timestamp, bmi);
      }).toList();

      // Sort results based on the timestamp
      results.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      setState(() {
        bmiResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'BMI Graph',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: LineChart(
                  _createSampleData(),
                  swapAnimationDuration:
                      Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Past BMI Results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: bmiResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Result ${index + 1}'),
                    subtitle: Text(
                        'BMI: ${bmiResults[index].bmi.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _createSampleData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: bmiResults
              .map((result) => FlSpot(
                  result.timestamp.millisecondsSinceEpoch.toDouble() /
                      1000000000,
                  result.bmi))
              .toList(),
          isCurved: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          color: Colors.blue,
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (value, meta) {
              final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  value.toInt() * 1000000000);
              return Text(
                '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}',
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          getTitlesWidget: (value, meta) {
            switch (value.toInt()) {
              case 10:
                return Text('10');
              case 20:
                return Text('20');
              case 30:
                return Text('30');
              case 40:
                return Text('40');
              default:
                return Text('');
            }
          },
        )),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
    );
  }
}

class BMIResult {
  final DateTime timestamp;
  final double bmi;

  BMIResult(this.timestamp, this.bmi);
}
