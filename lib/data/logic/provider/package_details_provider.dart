import 'package:flutter/material.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/package_repo.dart';
import 'package:user_servicehub/data/models/package_details_model.dart';

class PackageDetailsProvider extends ChangeNotifier {
  final _packageRepo = getIt<PackageRepo>();

  bool _isLoading = false;
  String? _error;
  PackageDetails? _details;

  bool get isLoading => _isLoading;
  String? get error => _error;
  PackageDetails? get details => _details;

  Future<void> fetchPackageDetails(String packageId) async {
    if (packageId.isEmpty || _isLoading) return;

    _isLoading = true;
    _error = null;
    _details = null;
    notifyListeners();

    final result = await _packageRepo.getPackageDetails(packageId: packageId);

    print('View Details tapped for package: ${packageId}  ${result}');
    if (result.isLeft()) {
      _isLoading = false;
      _error =
          result.getLeft().toNullable()?.message ??
          'Unable to load package details';
      notifyListeners();
      return;
    }

    _isLoading = false;
    _details = result.getRight().toNullable()?.data;
    notifyListeners();
  }

  void clear() {
    _details = null;
    _error = null;
    _isLoading = false;
  }
}
