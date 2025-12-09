import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tickoff/firebase_options.dart';
import 'package:tickoff/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

