class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? photoUrl;
  final String gender;
  final String dateOfBirth;
  final String language;
  final String? emergencyContact;
  final String address;
  final bool isVerified;
  final bool isGoldMember;
  final String customerSince;
  final double walletBalance;
  final int rewardPoints;
  final int totalBookings;
  final int completedBookings;
  final List<String> savedServiceIds;
  final List<String> favoriteProviderIds;
  final List<String> recentActivity;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.photoUrl,
    required this.gender,
    required this.dateOfBirth,
    required this.language,
    this.emergencyContact,
    required this.address,
    required this.isVerified,
    required this.isGoldMember,
    required this.customerSince,
    required this.walletBalance,
    required this.rewardPoints,
    required this.totalBookings,
    required this.completedBookings,
    this.savedServiceIds = const [],
    this.favoriteProviderIds = const [],
    this.recentActivity = const [],
  });

  factory UserModel.ramPrakash() => const UserModel(
        id: 'USR001',
        name: 'Ram Prakash',
        phone: '+91-9876543210',
        email: 'ram.prakash@email.com',
        photoUrl: 'assets/images/users/ram_prakash.jpg',
        gender: 'Male',
        dateOfBirth: '1992-04-15',
        language: 'Hindi',
        emergencyContact: '+91-9876543211',
        address: '42, Chandni Chowk, Old Delhi, Delhi - 110006',
        isVerified: true,
        isGoldMember: true,
        customerSince: '2022-01-15',
        walletBalance: 2450.75,
        rewardPoints: 2500,
        totalBookings: 12,
        completedBookings: 10,
        savedServiceIds: ['SV001', 'SV003', 'SV005', 'SV007'],
        favoriteProviderIds: ['PRF001', 'PRF003', 'PRF005'],
        recentActivity: [
          'Booked AC Repair - 28 Jul 2026',
          'Completed Plumbing service - 22 Jul 2026',
          'Rated Electrician 5 stars - 20 Jul 2026',
          'Added ₹500 to wallet - 18 Jul 2026',
        ],
      );

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    String? gender,
    String? dateOfBirth,
    String? language,
    String? emergencyContact,
    String? address,
    bool? isVerified,
    bool? isGoldMember,
    String? customerSince,
    double? walletBalance,
    int? rewardPoints,
    int? totalBookings,
    int? completedBookings,
    List<String>? savedServiceIds,
    List<String>? favoriteProviderIds,
    List<String>? recentActivity,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        language: language ?? this.language,
        emergencyContact: emergencyContact ?? this.emergencyContact,
        address: address ?? this.address,
        isVerified: isVerified ?? this.isVerified,
        isGoldMember: isGoldMember ?? this.isGoldMember,
        customerSince: customerSince ?? this.customerSince,
        walletBalance: walletBalance ?? this.walletBalance,
        rewardPoints: rewardPoints ?? this.rewardPoints,
        totalBookings: totalBookings ?? this.totalBookings,
        completedBookings: completedBookings ?? this.completedBookings,
        savedServiceIds: savedServiceIds ?? this.savedServiceIds,
        favoriteProviderIds: favoriteProviderIds ?? this.favoriteProviderIds,
        recentActivity: recentActivity ?? this.recentActivity,
      );
}
