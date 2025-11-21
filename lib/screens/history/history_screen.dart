import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/history/widgets/record_card.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:attendance_app/services/firestore_services.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AuthServices _authServices = AuthServices();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = _authServices.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(
          'Attendance History'
        )),
        body: Center(
          child: Text(
            'please login to view history'
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance History'
        ),
      ),
      body: StreamBuilder<List<AttendanceRecord>>(
        stream: _firestoreService.getAttendanceRecords(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'),);
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) => RecordCard(record: records[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No attendance record yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600]
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Check-in to start tracking ur attendance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500]
            ),
          )
        ],
      ),
    );
  }
}