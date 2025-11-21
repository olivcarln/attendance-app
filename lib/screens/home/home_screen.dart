import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/home/action_button.dart';
import 'package:attendance_app/screens/home/profile_card.dart';
import 'package:attendance_app/screens/widgets/attendance_card.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:attendance_app/services/firestore_services.dart';
import 'package:attendance_app/services/storage_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthServices _authServices = AuthServices();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageServices _storageServices = StorageServices();
  AttendanceRecord? _todayRecord;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _listenToTodayRecord();
  }

  void _listenToTodayRecord() {
    final user = _authServices.currentUser;
    if (user != null) {
      _firestoreService.getTodayRecordStream(user.uid).listen((record) {
        if (mounted) setState(() => _todayRecord = record);
      });
    }
  }

  Future<void> _checkIn({String? photoPath}) async {
    final user = _authServices.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      String? photoKey;
      if (photoPath != null) {
        photoKey = await _storageServices.uploadAttendancePhoto(
          photoPath,
          'checkin',
        );
      }

      final now = DateTime.now();
      final record = AttendanceRecord(
        id: '',
        userId: user.uid,
        checkInTime: now,
        date: DateTime(now.year, now.month, now.day),
        checkInPhotoPath: photoKey,
      );

      await _firestoreService.createAttendanceRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              photoPath != null
                  ? 'Check in successfully with photo!'
                  : 'Check in successfully',
            ),

            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking in: ${e.toString()}'),
          backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future <void> _checkOut({String? photoPath}) async {
    if (_todayRecord == null) return;

    setState(() => _isLoading = true);
    try {
      String? photoKey;
      if (photoPath != null) {
        photoKey =  await _storageServices.uploadAttendancePhoto(
          photoPath, 'checkout'
        );   }

        final updateRecord = AttendanceRecord(
          id: _todayRecord!.id,
          userId: _todayRecord!.userId,
          checkInTime: _todayRecord!.checkInTime,
          checkOutTime: DateTime.now(),
          date: _todayRecord!.date,
          checkInPhotoPath: _todayRecord!.checkInPhotoPath,
          checkOutPhotoPath: photoKey

        );

        await _firestoreService.updateAttendanceRecord(updateRecord);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(photoPath != null ? 'Checked out successfully with photo!' : 'Checked out successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            )
          );
        }
    
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
            'Failed to checkout: ${e.toString()}'
          ),
          backgroundColor: Colors.red,
          )
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false); 
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Attendance Tracker'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              //TODO: Go to history screen
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async => await _authServices.signOut() ,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[700]!,
              Colors.grey[50]!,
            ],
            stops: [0, 0, 0.3]
          )
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileCard(),
              SizedBox(height: 24),
              AttendanceCard(todayRecord: _todayRecord),
              SizedBox(height: 24),
                ActionButton(
                  todayRecord: _todayRecord,
                  isLoading: _isLoading,
                  onCheckIn: () => _checkIn(),
                  onCheckOut: () => _checkOut(),
                  onCheckInWithPhoto: (path) => _checkIn(photoPath: path),
                  onCheckOutWithPhoto: (path) => _checkOut(photoPath: path),
                )
            ],
          ),
        ),
      ),
    );
  }
}
