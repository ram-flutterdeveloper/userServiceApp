import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/profile_repo.dart';
import 'package:user_servicehub/data/models/profile_response_model.dart';

class ProfileProvider with ChangeNotifier {
  final _profileRepo = getIt<ProfileRepo>();
  final _imagePicker = ImagePicker();

  ProfileData? _profile;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _error;
  String? _updateError;

  File? _profileImageFile;
  bool _isPickingImage = false;

  String _gender = 'MALE';
  String _dob = '';
  bool _isDobDirty = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ProfileData? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get error => _error;
  String? get updateError => _updateError;
  File? get profileImageFile => _profileImageFile;
  bool get isPickingImage => _isPickingImage;
  String get gender => _gender;
  String get dob => _dob;
  bool get isDobDirty => _isDobDirty;

  String get displayGender {
    switch (_gender.toUpperCase()) {
      case 'MALE':
        return 'Male';
      case 'FEMALE':
        return 'Female';
      case 'OTHER':
        return 'Other';
      default:
        return 'Male';
    }
  }

  String get displayDob {
    if (_dob.isEmpty) return 'Select date of birth';
    return _dob;
  }

  String get displayPhone {
    if (_profile == null || _profile!.mobile == null) return '';
    final cc = _profile!.countryCode ?? '+91';
    final mobile = _profile!.mobile!;
    if (mobile.length >= 6) {
      final masked =
          mobile
              .substring(0, mobile.length - 4)
              .replaceAll(RegExp(r'\d'), '*') +
          mobile.substring(mobile.length - 4);
      return '$cc $masked';
    }
    return '$cc $mobile';
  }

  String get fullPhone {
    if (_profile == null || _profile!.mobile == null) return '';
    final cc = _profile!.countryCode ?? '+91';
    return '$cc ${_profile!.mobile}';
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _profileRepo.fetchProfile();

    if (result.isLeft()) {
      _isLoading = false;
      _error =
          result.getLeft().toNullable()?.message ?? 'Failed to load profile';
      notifyListeners();
      return;
    }

    final profile = result.getRight().toNullable();
    _profile = profile;
    _applyProfileToForm(profile);
    _isLoading = false;
    notifyListeners();
  }

  void _applyProfileToForm(ProfileData? profile) {
    print("ksdfg ${profile!.profileImage}");
    if (profile == null) return;
    firstNameController.text = profile.firstName ?? '';
    lastNameController.text = profile.lastName ?? '';
    emailController.text = profile.email ?? '';
    _gender = _normalizeGender(profile.gender);
    _dob = _normalizeDob(profile.dob);
    _isDobDirty = false;
    _profileImageFile = null;
  }

  String _normalizeGender(String? g) {
    final v = (g ?? '').toUpperCase();
    if (v == 'MALE' || v == 'FEMALE' || v == 'OTHER') return v;
    return 'MALE';
  }

  String _normalizeDob(String? dob) {
    if (dob == null || dob.isEmpty) return '';
    return dob.split('T').first;
  }

  void setGender(String value) {
    final upper = value.toUpperCase();
    if (_gender != upper) {
      _gender = upper;
      notifyListeners();
    }
  }

  Future<void> setDateOfBirth(DateTime date) async {
    final formatted =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    if (_dob != formatted) {
      _dob = formatted;
      _isDobDirty = true;
      notifyListeners();
    }
  }

  Future<bool> pickProfileImage(ImageSource source) async {
    _isPickingImage = true;
    _updateError = null;
    notifyListeners();
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (picked == null) {
        _isPickingImage = false;
        notifyListeners();
        return false;
      }
      _profileImageFile = File(picked.path);
      _isPickingImage = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isPickingImage = false;
      _updateError = 'Could not pick the image. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void removeProfileImage() {
    _profileImageFile = null;
    notifyListeners();
  }

  Future<bool> updateProfile() async {
    _isUpdating = true;
    _updateError = null;
    notifyListeners();

    print("check the ${_buildFormData()}");

    final result = await _profileRepo.updateProfile(await _buildFormData());

    if (result.isLeft()) {
      _isUpdating = false;
      _updateError =
          result.getLeft().toNullable()?.message ?? 'Failed to update profile';
      notifyListeners();
      return false;
    }

    final updated = result.getRight().toNullable();
    if (updated != null) {
      _profile = updated;
      _applyProfileToForm(updated);
    }
    _isUpdating = false;
    notifyListeners();
    return true;
  }

  Future<FormData> _buildFormData() async {
    final fields = <String, dynamic>{
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'gender': _gender,
      'dob': _dob,
    };

    if (_profileImageFile != null) {
      fields['profileImage'] = await MultipartFile.fromFile(
        _profileImageFile!.path,
        filename: _profileImageFile!.path.split('/').last,
      );
    } else {
      fields['profileImage'] = _profile?.profileImage ?? '';
    }

    return FormData.fromMap(fields);
  }

  void clearUpdateError() {
    _updateError = null;
    notifyListeners();
  }
}
