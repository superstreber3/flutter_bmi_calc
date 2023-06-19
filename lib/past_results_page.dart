import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
                child: charts.TimeSeriesChart(
                  _createSampleData(),
                  animate: true,
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 12,
                        color: charts.MaterialPalette.white,
                      ),
                      lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.white,
                      ),
                    ),
                  ),
                  domainAxis: charts.DateTimeAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 12,
                        color: charts.MaterialPalette.white,
                      ),
                      lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.white,
                      ),
                    ),
                  ),
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
                    subtitle: Text('BMI: ${bmiResults[index].bmi}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<BMIResult, DateTime>> _createSampleData() {
    return [
      charts.Series<BMIResult, DateTime>(
        id: 'BMI Results',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BMIResult result, _) => result.timestamp,
        measureFn: (BMIResult result, _) => result.bmi,
        data: bmiResults,
      ),
    ];
  }
}

class BMIResult {
  final DateTime timestamp;
  final double bmi;

  BMIResult(this.timestamp, this.bmi);
}
