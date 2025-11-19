import 'package:attendance_app/wrapper/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD6fbj2ycx27mV90Eael0enMLxaaiVoK5U", 
      appId: "1:212529429713:android:ef0dd78886fdfaf46e99f0",
       messagingSenderId: "212529429713",
        projectId: "attendance-app-fbb1c",
        )
  );
  runApp(AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light, 
         ),
         useMaterial3: true,
         appBarTheme: AppBarTheme(
          centerTitle: true,
         )
      ),
      home: AuthWrapper(),
    );
  }
}