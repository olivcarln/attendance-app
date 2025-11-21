import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/widgets/photo_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  final AttendanceRecord record;

  const RecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final isComplete = record.checkOutTime != null;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isComplete),
            Divider(height: 24,),
            _buildTimeInfo(isComplete),
            if (record.checkInPhotoPath != null || record.checkOutPhotoPath != null) 
              _buildPhotos(),
            if(record.notes !=null && record.notes!.isEmpty)
            _buildNotes()
          ],
        ),
       ),
    );
    
    
  }

  Widget _buildHeader (BuildContext context, bool isComplete) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('EEEE, MMM, d, yyyy').format(record.date),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isComplete ? Colors.green[100] : Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isComplete ? 'Complete' : 'In Progress',
            style: TextStyle(
              color: isComplete ? Colors.green[900] : Colors.orange[900],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        )
        
      ],
    );
  }

  Widget _buildTimeInfo(bool isComplete) {
    return Row(
      children: [
        Expanded(
          child: infoColumn(
            icon: Icons.login,
            label: 'Check In',
            value: DateFormat('hh:mm a').format(record.checkInTime),
          ),
        ),
        if (isComplete) ...[
          Expanded(
            child: infoColumn(
              icon: Icons.logout,
              label: 'Check Out',
              value: DateFormat('hh:mm a').format(record.checkOutTime!),
            ),
          ),
          if(record.totalHours != null)
          Expanded(
            child: infoColumn(
              icon: Icons.timer,
              label: 'Total',
              value: _formatDuration(record.totalHours!),
            ))
        ]
      ],
    );
  }

  Widget _buildPhotos() {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (record.checkInPhotoPath != null)
            Expanded(
              child: PhotoViewer(
                photoKey: record.checkInPhotoPath,
                label: 'Check-in Photo'
              ),
            ),
            if (record.checkInPhotoPath !=null && record.checkOutPhotoPath != null)
              SizedBox(width: 8),
            if(record.checkOutPhotoPath != null)
              Expanded(
                child: PhotoViewer(
                  photoKey: record.checkOutPhotoPath, 
                  label: 'Check-out photo'))
        ],
      ),
    );
  }

  Widget _buildNotes() {
    return Padding(
      padding: EdgeInsets.only(top: 12), 
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.note, size: 16, color: Colors.grey[600]),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                record.notes!,
                style: TextStyle(
                  color: Colors.grey[700]
                ),
              )
              )
          ],
        ),
      ),
      );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours}h ${minutes}m';

  }
}

class infoColumn extends StatelessWidget {

  final IconData icon;
  final String label;
  final String value;
  const infoColumn({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        SizedBox(height: 4), 
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith (
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 2),
        Text(
          value, 
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}