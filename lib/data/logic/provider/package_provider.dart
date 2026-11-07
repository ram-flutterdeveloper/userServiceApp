import 'package:flutter/material.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/package_repo.dart';
import 'package:user_servicehub/data/models/home_response_model.dart';
import 'package:user_servicehub/data/models/timeSlot_response.dart';

class PackageProvider with ChangeNotifier {
  final _packageRepo = getIt<PackageRepo>();

  bool _isLoading = false;
  String? _error;
  List<PopularPackage> _packages = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<PopularPackage> get packages => _packages;

  Future<void> fetchPackages(String serviceId) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _packages = [];
    notifyListeners();

    final result = await _packageRepo.getPackagesByService(
      serviceId: serviceId,
    );

    if (result.isLeft()) {
      _isLoading = false;
      _error =
          result.getLeft().toNullable()?.message ?? 'Failed to load packages';
      notifyListeners();
      return;
    }

    _isLoading = false;
    _packages = result.getRight().toNullable() ?? [];
    notifyListeners();
  }

  // Future<void> fetchTimeSlot(String serviceId) async {
  //   if (_isLoading) return;

  //   _isLoading = true;
  //   _error = null;
  //   _packages = [];
  //   notifyListeners();

  //   final result = await _packageRepo.timeSlot();

  //   if (result.isLeft()) {
  //     _isLoading = false;
  //     _error =
  //         result.getLeft().toNullable()?.message ?? 'Failed to load packages';
  //     notifyListeners();
  //     return;
  //   }

  //   _isLoading = false;
  //   _packages = result.getRight().toNullable() ?? [];
  //   notifyListeners();
  // }


  void clear() {
    _packages = [];
    _error = null;
    _isLoading = false;
  }
}
