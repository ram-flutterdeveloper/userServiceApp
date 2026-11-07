import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
  bool? success;
  String? message;
  ProfileData? data;

  ProfileResponse({this.success, this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileData {
  String? id;
  String? mobile;
  String? countryCode;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  String? gender;
  String? dob;
  bool? isMobileVerified;
  bool? isProfileCompleted;
  String? status;
  String? role;
  String? googleId;
  String? authProvider;
  bool? isEmailVerified;
  int? providerSignupStep;
  String? createdAt;
  String? updatedAt;

  ProfileData({
    this.id,
    this.mobile,
    this.countryCode,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    this.gender,
    this.dob,
    this.isMobileVerified,
    this.isProfileCompleted,
    this.status,
    this.role,
    this.googleId,
    this.authProvider,
    this.isEmailVerified,
    this.providerSignupStep,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName =>
      [firstName ?? '', lastName ?? ''].where((e) => e.isNotEmpty).join(' ').trim();

  String get nameInitial => fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    mobile: json["mobile"],
    countryCode: json["countryCode"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    dob: json["dob"],
    isMobileVerified: json["isMobileVerified"],
    isProfileCompleted: json["isProfileCompleted"],
    status: json["status"],
    role: json["role"],
    googleId: json["googleId"],
    authProvider: json["authProvider"],
    isEmailVerified: json["isEmailVerified"],
    providerSignupStep: json["providerSignupStep"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile": mobile,
    "countryCode": countryCode,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "profileImage": profileImage,
    "gender": gender,
    "dob": dob,
    "isMobileVerified": isMobileVerified,
    "isProfileCompleted": isProfileCompleted,
    "status": status,
    "role": role,
    "googleId": googleId,
    "authProvider": authProvider,
    "isEmailVerified": isEmailVerified,
    "providerSignupStep": providerSignupStep,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
