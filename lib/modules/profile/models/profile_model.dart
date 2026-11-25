class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final int isVerified;
  final String? memberType;
  final DateTime? createdAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.isVerified = 0,
    this.memberType,
    this.createdAt,
  });

  bool get isTempoMember => memberType?.toLowerCase() == 'tempo';

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      avatar: json['avatar']?.toString(),
      isVerified: json['is_verified'] as int? ?? 0,
      memberType: json['member_type']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'is_verified': isVerified,
      'member_type': memberType,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}