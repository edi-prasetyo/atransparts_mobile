class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final int isVerified;
  final String? email;
  final String? phone;
  final String? otpExpiresAt;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.isVerified = 0,
    this.email,
    this.phone,
    this.otpExpiresAt,
  });

  static int _toIntVerify(dynamic v) {
    if (v is int) return v;
    if (v is bool) return v ? 1 : 0;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static int _toIntExpires(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final v = user?['is_verified'] ?? json['is_verified'];
    return AuthResponse(
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
      expiresIn: _toIntExpires(json['expires_in']),
      email: (user?['email'] ?? json['email'])?.toString(),
      phone: (user?['phone'] ?? json['phone'])?.toString(),
      isVerified: _toIntVerify(v),
      otpExpiresAt: (user?['otp_expires_at'] ?? json['otp_expires_at'])?.toString(),
    );
  }
}
