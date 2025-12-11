import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickoff/firebase_options.dart';
import 'package:tickoff/src/app.dart';
import 'package:tickoff/src/services/tick_bite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize device user ID for tracking user's own tick bites
  final prefs = await SharedPreferences.getInstance();
  String? deviceId = prefs.getString('device_user_id');
  if (deviceId == null) {
    deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
    await prefs.setString('device_user_id', deviceId);
  }
  TickBiteService.setDeviceUserId(deviceId);
  
  runApp(const MyApp());
}

