import 'package:firebase_core/firebase_core.dart';
import 'package:firebbase/apps.dart';
import 'package:firebbase/firebase_options.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const App(),
  );
}
