class InvestorProfileResponse {
  final InvestorProfile profile;
  final ProfileStats stats;

  const InvestorProfileResponse({required this.profile, required this.stats});

  factory InvestorProfileResponse.fromJson(Map<String, dynamic> json) {
    return InvestorProfileResponse(
      profile: InvestorProfile.fromJson(
        Map<String, dynamic>.from(json['profile'] as Map? ?? {}),
      ),
      stats: ProfileStats.fromJson(
        Map<String, dynamic>.from(json['stats'] as Map? ?? {}),
      ),
    );
  }
}

class InvestorProfile {
  final String name;
  final String email;
  final String phone;
  final String? profileImage;

  const InvestorProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
  });

  String get initial =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  factory InvestorProfile.fromJson(Map<String, dynamic> json) {
    return InvestorProfile(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
    );
  }
}

class ProfileStats {
  final int properties;
  final int shares;
  final num returns;

  const ProfileStats({
    required this.properties,
    required this.shares,
    required this.returns,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      properties: _toInt(json['properties']),
      shares: _toInt(json['shares']),
      returns: json['returns'] as num? ?? 0,
    );
  }

  static int _toInt(dynamic value) => value is num ? value.toInt() : 0;
}
