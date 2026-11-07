import 'package:flutter/foundation.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/favourite_repo.dart';
import 'package:user_servicehub/data/logic/repo/package_repo.dart';
import 'package:user_servicehub/data/models/service_model.dart';

class FavouriteProvider with ChangeNotifier {
  final _favouriteRepo = getIt<FavouriteRepo>();
  final _packageRepo = getIt<PackageRepo>();

  bool _isLoading = false;
  bool _isLoadingPackages = false;
  String? _error;
  String? _packagesError;
  List<ServiceModel> _savedServices = [];
  List<ServiceModel> _packages = [];

  bool get isLoading => _isLoading;
  bool get isLoadingPackages => _isLoadingPackages;
  String? get error => _error;
  String? get packagesError => _packagesError;
  List<ServiceModel> get savedServices => _savedServices;
  List<ServiceModel> get packages => _packages;

  Future<void> fetchFavourites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _favouriteRepo.getFavourites();

    if (result.isLeft()) {
      _isLoading = false;
      _error =
          result.getLeft().toNullable()?.message ?? 'Failed to load favourites';
      notifyListeners();
      return;
    }

    _isLoading = false;
    _savedServices = result.getRight().toNullable() ?? [];
    notifyListeners();
  }

  Future<bool> removeFavourite(ServiceModel service) async {
    final result = await _favouriteRepo.removeFavourite(service.id);
    if (result.isLeft()) return false;

    _savedServices.removeWhere((s) => s.id == service.id);
    notifyListeners();
    return true;
  }

  Future<void> fetchPackages() async {
    _isLoadingPackages = true;
    _packagesError = null;
    notifyListeners();

    final result = await _packageRepo.getAllPackages();

    if (result.isLeft()) {
      _isLoadingPackages = false;
      _packagesError =
          result.getLeft().toNullable()?.message ?? 'Failed to load packages';
      notifyListeners();
      return;
    }

    _isLoadingPackages = false;
    _packages = result.getRight().toNullable() ?? [];
    notifyListeners();
  }

  bool isFavourite(String packageId) =>
      _savedServices.any((s) => s.id == packageId);

  Future<bool> toggleFavourite(String packageId) async {
    final existing = _savedServices.where((s) => s.id == packageId).toList();
    if (existing.isNotEmpty) {
      return await removeFavourite(existing.first);
    }

    final result = await _favouriteRepo.addFavourite(packageId);
    if (result.isLeft()) return false;

    await fetchFavourites();
    return true;
  }

  void clear() {
    _savedServices = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}