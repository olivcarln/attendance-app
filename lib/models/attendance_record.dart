class AttendanceRecord {
  final String id;
  final String userId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final DateTime date;
  final String? location;
  final String? notes;
  final String? checkInPhotoPath;
  final String? checkOutPhotoPath;

  AttendanceRecord({required this.id, required this.userId, required this.checkInTime, this.checkOutTime, required this.date, this.location, this.notes, this.checkInPhotoPath, this.checkOutPhotoPath});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      checkInTime: DateTime.parse(json['check_in_time'] as String),
      checkOutTime: json['check_out_time'] != null ? DateTime.parse(json['check_out_time'] as String) : null,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      checkInPhotoPath: json['check_in_photo_path'] as String?,
      checkOutPhotoPath: json['check_out_photo_path'] as String?,
   
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'user_id':userId,
      'check_in_time': checkInTime.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'date': date.toIso8601String().split('T')[0],
      'location': location,
      'notes': notes,
      'check_in_photo_path': checkInPhotoPath,
      'check_out_photo_path': checkOutPhotoPath,
    };
  }

  Duration? get totalHours {
    if (checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime);
  }
}
