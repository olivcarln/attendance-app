import 'package:attendance_app/models/attendance_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // firestore untuk menyimpan semua data, database realtime => yg berkaitan dg gambar saja
  // get attendance records for user (real-time stream)
  Stream<List<AttendanceRecord>> getAttendanceRecords(String userId) {
    // get attendance record
    return _firestore
        .collection('attendance')
        .where('user_id', isEqualTo: userId)
        .orderBy('check_in_time', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AttendanceRecord.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  // today's attendance record (real-time screen)
  Stream<AttendanceRecord?> getTodayRecordStream(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    return _firestore
        .collection('attendance')
        .where('user_id', isEqualTo: userId)
        .orderBy('check_in_time', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          // filter today record on client side
          for (var doc in snapshot.docs) {
            final data = doc.data();
            final checkInTime = DateTime.parse(data['check_in_time'] as String);

            if (checkInTime.isAfter(startOfDay) && checkInTime.isBefore(endOfDay)) {
              return AttendanceRecord.fromJson({...data, 'id': doc.id});
            }
          }

          return null;
        });
  }

  // get today's attendance record (one-time fetch) => pemanggilannya hanya sekali
  Future<AttendanceRecord?> getTodayRecord(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final querySnapshot = await _firestore
        .collection('attendance')
        .where('user_id', isEqualTo: userId)
        .where('date', isGreaterThan: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

        if (querySnapshot.docs.isEmpty) return null;

        return AttendanceRecord.fromJson(
          {...querySnapshot.docs.first.data(), 'id': querySnapshot.docs.first.id}
        );
  }
  // create new attendance record
  Future<String> createAttendanceRecord(AttendanceRecord record) async {
    final docRef = await _firestore.collection('attendance').add(record.toJson());
    return docRef.id;
  }

  // update existing attendance record 
  Future<void> updateAttendanceRecord(AttendanceRecord record) async {
    await _firestore 
        .collection('attendance')
        .doc(record.id)
        .update(record.toJson());
  }

  // create or upload attendance record 
  Future<void> saveAttendanceRecord(AttendanceRecord record) async {
    if (record.id == '1' || record.id.isEmpty) {
      // new record for creating auto generated id
      await createAttendanceRecord(record);
    } else {
      // update existing record
      await updateAttendanceRecord(record);
    }
  }
}