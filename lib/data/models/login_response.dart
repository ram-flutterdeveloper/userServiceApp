// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool? success;
  String? message;
  LoginData? data;

  LoginResponse({this.success, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : LoginData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class LoginData {
  LoginUser? user;
  dynamic provider;
  String? accessToken;
  String? refreshToken;
  String? otp;
  int? expiresIn;

  LoginData({
    this.user,
    this.provider,
    this.accessToken,
    this.refreshToken,
    this.otp,
    this.expiresIn,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    user: json["user"] == null ? null : LoginUser.fromJson(json["user"]),
    provider: json["provider"],
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    otp: json["otp"],
    expiresIn: json["expiresIn"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "provider": provider,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "otp": otp,
    "expiresIn": expiresIn,
  };
}

class LoginUser {
  String? id;
  String? mobile;
  String? countryCode;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  String? gender;
  String? dateOfBirth;
  bool? isMobileVerified;
  bool? isProfileCompleted;
  String? status;
  String? role;
  String? authProvider;
  bool? isEmailVerified;
  int? providerSignupStep;
  String? googleId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  LoginUser({
    this.id,
    this.mobile,
    this.countryCode,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    this.gender,
    this.dateOfBirth,
    this.isMobileVerified,
    this.isProfileCompleted,
    this.status,
    this.role,
    this.authProvider,
    this.isEmailVerified,
    this.providerSignupStep,
    this.googleId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  String get name =>
      [
        firstName ?? '',
        lastName ?? '',
      ].where((e) => e.isNotEmpty).join(' ').trim();

  String get phone => mobile ?? '';

  String get address => '';

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
    id: json["id"],
    mobile: json["mobile"],
    countryCode: json["countryCode"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    dateOfBirth: json["dob"],
    isMobileVerified: json["isMobileVerified"],
    isProfileCompleted: json["isProfileCompleted"],
    status: json["status"],
    role: json["role"],
    authProvider: json["authProvider"],
    isEmailVerified: json["isEmailVerified"],
    providerSignupStep: json["providerSignupStep"],
    googleId: json["googleId"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    deletedAt: json["deletedAt"],
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
    "dob": dateOfBirth,
    "isMobileVerified": isMobileVerified,
    "isProfileCompleted": isProfileCompleted,
    "status": status,
    "role": role,
    "authProvider": authProvider,
    "isEmailVerified": isEmailVerified,
    "providerSignupStep": providerSignupStep,
    "googleId": googleId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "deletedAt": deletedAt,
  };
}
