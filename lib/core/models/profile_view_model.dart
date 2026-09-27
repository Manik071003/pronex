class ProfileResponse {
  final bool success;
  final String message;
  final User user;

  ProfileResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['data']['user']),
    );
  }
}

class User {
  final String id;
  final String phoneNumber;
  final String countryCode;
  final String name;
  final String email;
  final bool isVerified;
  final String firstName;
  final String lastName;
  final int height;
  final String bio;
  final DateTime dateOfBirth;
  final bool isAgeConfirmed;
  final String gender;
  final List<Interest> interests;
  final List<InterestSelection> interestSelections;
  final String activeProfilePhoto;
   List<String> profilePhotos;
  final bool isPhotoVerified;
  final String verificationStatus;
  final String referralCode;
  final String? relationshipGoal;
  final String? smokingHabit;
  final String? drinkingHabit;
  final String? education;
  final String? occupation;
  final String location;
  final bool isLocation;
  final List<String> languages;
  final bool voucherRedeemed;
  final bool didFirstSwipe;
  final dynamic personalityScore;
  final bool personalityTestCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.phoneNumber,
    required this.countryCode,
    required this.name,
    required this.email,
    required this.isVerified,
    required this.firstName,
    required this.lastName,
    required this.height,
    required this.bio,
    required this.dateOfBirth,
    required this.isAgeConfirmed,
    required this.gender,
    required this.interests,
    required this.interestSelections,
    required this.activeProfilePhoto,
    required this.profilePhotos,
    required this.isPhotoVerified,
    required this.verificationStatus,
    required this.referralCode,
    this.relationshipGoal,
    this.smokingHabit,
    this.drinkingHabit,
    this.education,
    this.occupation,
    required this.location,
    required this.isLocation,
    required this.languages,
    required this.voucherRedeemed,
    required this.didFirstSwipe,
    this.personalityScore,
    required this.personalityTestCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['isVerified'] ?? false,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      height: json['height'] ?? 0,
      bio: json['bio'] ?? '',
      dateOfBirth: DateTime.tryParse(json['dateOfBirth'] ?? '') ?? DateTime.now(),
      isAgeConfirmed: json['isAgeConfirmed'] ?? false,
      gender: json['gender'] ?? '',
      interests: (json['interests'] as List? ?? [])
          .map((e) => Interest.fromJson(e))
          .toList(),
      interestSelections: (json['interestSelections'] as List? ?? [])
          .map((e) => InterestSelection.fromJson(e))
          .toList(),
      activeProfilePhoto: json['activeProfilePhoto'] ?? '',
      profilePhotos: List<String>.from(json['profilePhotos'] ?? []),
      isPhotoVerified: json['isPhotoVerified'] ?? false,
      verificationStatus: json['verificationStatus'] ?? '',
      referralCode: json['referralCode'] ?? '',
      relationshipGoal: json['relationshipGoal'],
      smokingHabit: json['smokingHabit'],
      drinkingHabit: json['drinkingHabit'],
      education: json['education'],
      occupation: json['occupation'],
      location: json['location'] ?? '',
      isLocation: json['isLocation'] ?? false,
      languages: List<String>.from(json['languages'] ?? []),
      voucherRedeemed: json['voucherRedeemed'] ?? false,
      didFirstSwipe: json['didFirstSwipe'] ?? false,
      personalityScore: json['personalityScore'],
      personalityTestCompleted: json['personalityTestCompleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
class Interest {
  final String id;
  final String title;
  final List<Category> categories;

  Interest({
    required this.id,
    required this.title,
    required this.categories,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      categories: (json['categories'] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}
class Category {
  final String id;
  final String title;

  Category({
    required this.id,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
    );
  }
}
class InterestSelection {
  final String interestId;
  final List<String> categoryIds;

  InterestSelection({
    required this.interestId,
    required this.categoryIds,
  });

  factory InterestSelection.fromJson(Map<String, dynamic> json) {
    return InterestSelection(
      interestId: json['interestId'] ?? '',
      categoryIds: List<String>.from(json['categoryIds'] ?? []),
    );
  }
}