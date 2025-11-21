import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/widgets/photo_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceRecord? todayRecord;

  const AttendanceCard({super.key, this.todayRecord});

  @override
  Widget build(BuildContext context) {
    final hasCheckedIn = todayRecord != null;
    final hasCheckedOut = todayRecord?.checkOutTime != null;

    final (cardColor, iconColor, iconData, statusText) = _getCardStyle(hasCheckedIn, hasCheckedOut);  // ini biar reusable soalnya ada 3 jenis card (not checkin, currently workin, complete)

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardColor
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _buildIconCntainer(iconData, iconColor),
            SizedBox(height: 16),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: iconColor
              ),
            ),
            if (hasCheckedIn)...[
              SizedBox(height: 20),
              _buildTimeDetails(iconColor),
              if (todayRecord!.checkInPhotoPath != null || todayRecord!.checkOutPhotoPath != null)
              _buildPhotoRow(),
            ]
          ],
        ),
      ),
    );
  }

  (Color, Color, IconData, String) _getCardStyle(bool hasCheckedIn, bool hasCheckedOut) {
    if (!hasCheckedIn) {
      return (Colors.orange[50]!, Colors.orange[600]!, Icons.access_time_rounded, 'Not Check In');
    } else if (hasCheckedOut) {
      return (Colors.green[50]!, Colors.green[600]!, Icons.check_circle_rounded, 'Work Complete');
    } else {
      return (Colors.blue[50]!, Colors.blue[600]!, Icons.work_rounded, 'Currently Working');
    }
  }

  Widget _buildIconCntainer(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2
          )
        ]
      ),
      child: Icon(icon, size: 48, color: color),
    );
  }

  Widget _buildTimeDetails(Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [
          _TimeRow(
            icon: Icons.login_rounded,
            label: 'check_in',
            value: DateFormat('hh:mm a').format(todayRecord!.checkInTime),
            color: color,
          ),
          if (todayRecord!.checkOutTime != null) ...[
            SizedBox(height: 12),
             _TimeRow(
            icon: Icons.login_rounded,
            label: 'check_out',
            value: DateFormat('hh:mm a').format(todayRecord!.checkOutTime!),
            color: color,
          ),
          ]
        ],
      ),
    );
  }

  Widget _buildPhotoRow() {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (todayRecord!.checkInPhotoPath != null)
            Expanded(
              child: PhotoViewer(
                photoKey: todayRecord!.checkInPhotoPath,
                label: 'Check-In',
              ),
            ),
            if (todayRecord!.checkInPhotoPath != null && todayRecord!.checkOutPhotoPath != null)
              SizedBox(width: 8),
            if (todayRecord!.checkOutPhotoPath != null)
              Expanded(
                child: PhotoViewer(
                  photoKey: todayRecord!.checkOutPhotoPath,
                  label: 'Check-Out',
                ),
              )
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _TimeRow({super.key, required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color
          ),
        )
      ],
    );
  }
}