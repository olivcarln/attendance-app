import 'package:attendance_app/models/attendance_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get attendance records for a user (real-time stream)
  Stream<List<AttendanceRecord>> getAttendanceRecords(String userId) {
    return 'Hello!';
  }
}