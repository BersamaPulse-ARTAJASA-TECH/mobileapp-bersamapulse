import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  final Health _health = Health();

  // Mendefinisikan jenis data kesehatan yang akan diakses
  final List<HealthDataType> _types = [
    HealthDataType.HEIGHT,
    HealthDataType.WEIGHT,
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_OXYGEN
  ];

  // Mendefinisikan izin akses yang sesuai
  final List<HealthDataAccess> _permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ
  ];

  // Meminta izin runtime untuk Android
  Future<void> requestAdditionalPermissions() async {
    await [
      Permission.activityRecognition,
      Permission.location,
    ].request();
  }

  // Meminta izin ke Health API
  Future<bool> requestPermissions() async {
    await requestAdditionalPermissions(); // Meminta izin tambahan

    // Memastikan list `types` dan `permissions` sama panjang
    if (_types.length != _permissions.length) {
      throw ArgumentError('The lists of types and permissions must be of the same length.');
    }

    // Cek apakah izin sudah diberikan
    bool? granted = await _health.hasPermissions(_types, permissions: _permissions);
    if (granted == false) {
      // Meminta izin jika belum diberikan
      granted = await _health.requestAuthorization(_types, permissions: _permissions);
    }

    return granted ?? false;
  }

  // Mengambil data kesehatan
  Future<List<HealthDataPoint>> getHealthData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    List<HealthDataPoint> healthData = [];

    try {
      healthData = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: yesterday,
        endTime: now,
      );

      // Menghapus duplikat data
      healthData = _health.removeDuplicates(healthData);
    } catch (e) {
      print("Error in getHealthData: $e");
    }

    return healthData;
  }
}
