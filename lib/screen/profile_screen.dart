import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap field
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _oxygenSaturationController = TextEditingController();
  final _heartRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    // Menghapus controller saat widget dibuang
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _bloodPressureController.dispose();
    _oxygenSaturationController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        // Mengisi controller dengan data dari Firestore dan handle jika null
        setState(() {
          _nameController.text = data['name'] ?? '';
          _heightController.text = data['height']?.toString() ?? '';
          _weightController.text = data['weight']?.toString() ?? '';
          _ageController.text = data['age']?.toString() ?? '';
          _bloodPressureController.text = data['bloodPressure'] ?? '';
          _oxygenSaturationController.text = data['oxygenSaturation']?.toString() ?? '';
          _heartRateController.text = data['heartRate']?.toString() ?? '';
        });
      }
    }
  }

  void _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user != null) {
        // Mengupdate data di Firestore dengan memastikan data yang kosong
        await _firestore.collection('users').doc(user.uid).update({
          'name': _nameController.text,
          'height': _heightController.text.isNotEmpty ? int.parse(_heightController.text) : null,
          'weight': _weightController.text.isNotEmpty ? int.parse(_weightController.text) : null,
          'age': _ageController.text.isNotEmpty ? int.parse(_ageController.text) : null,
          'bloodPressure': _bloodPressureController.text.isNotEmpty ? _bloodPressureController.text : null,
          'oxygenSaturation': _oxygenSaturationController.text.isNotEmpty ? int.parse(_oxygenSaturationController.text) : null,
          'heartRate': _heartRateController.text.isNotEmpty ? int.parse(_heartRateController.text) : null,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _bloodPressureController,
                decoration: InputDecoration(labelText: 'Blood Pressure'),
              ),
              TextFormField(
                controller: _oxygenSaturationController,
                decoration: InputDecoration(labelText: 'Oxygen Saturation (%)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _heartRateController,
                decoration: InputDecoration(labelText: 'Heart Rate'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
