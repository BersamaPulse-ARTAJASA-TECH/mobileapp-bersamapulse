import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthDataScreen extends StatefulWidget {
  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  List<HealthDataPoint> _healthDataList = [];
  String _healthStatus = 'No Data Fetched';

  // Daftar jenis data yang ingin diakses
  final List<HealthDataType> _types = [
    // HealthDataType.STEPS
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.HEART_RATE,
  ];
  final List<HealthDataAccess> _permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ
  ];

  @override
  void initState() {
    super.initState();
    _initializeHealth();
  }

  // Konfigurasi awal dan permintaan izin
  Future<void> _initializeHealth() async {
    Health().configure();
    await _requestPermissions();
    _fetchHealthData();
  }

  // Meminta izin akses data kesehatan
  Future<void> _requestPermissions() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? granted = await Health().hasPermissions(_types, permissions: _permissions);
    if (granted == null || !granted) {
      granted = await Health().requestAuthorization(_types, permissions: _permissions);
    }

    setState(() {
      _healthStatus = (granted ?? false) ? 'Authorized' : 'Authorization Failed';
    });
  }

  // Mengambil data kesehatan
  Future<void> _fetchHealthData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 5));

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: _types,
        startTime: yesterday,
        endTime: now,
      );

      setState(() {
        _healthDataList = Health().removeDuplicates(healthData);
        if (_healthDataList.isEmpty) {
          _healthStatus = 'No Data Available';
        } else {
          _healthStatus = 'Data Fetched Successfully';
        }
      });
    } catch (e) {
      setState(() {
        _healthStatus = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Health Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_healthStatus, style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: _fetchHealthData,
              child: Text('Fetch Health Data'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _healthDataList.length,
                itemBuilder: (context, index) {
                  HealthDataPoint dataPoint = _healthDataList[index];
                  return ListTile(
                    title: Text('${dataPoint.typeString}: ${dataPoint.value} ${dataPoint.unitString}'),
                    subtitle: Text('${dataPoint.dateFrom} - ${dataPoint.dateTo}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
