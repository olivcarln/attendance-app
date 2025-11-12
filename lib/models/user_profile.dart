class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final DateTime createdAt;

  UserProfile({required this.id, required this.email, required this.fullName, required this.createdAt});

  factory UserProfile.fromjs(Map<String, dynamic> json){
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String)
    );
  }
}