import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:user_servicehub/core/network_services/dio_client.dart';
import 'package:user_servicehub/data/logic/repo/address_repo.dart';
import 'package:user_servicehub/data/logic/repo/auth_repo.dart';
import 'package:user_servicehub/data/logic/repo/discovery_repo.dart';
import 'package:user_servicehub/data/logic/repo/favourite_repo.dart';
import 'package:user_servicehub/data/logic/repo/package_repo.dart';
import 'package:user_servicehub/data/logic/repo/profile_repo.dart';
import 'package:user_servicehub/data/logic/repo/review_repo.dart';
import 'package:user_servicehub/data/logic/services/address_service_locator.dart';
import 'package:user_servicehub/data/logic/services/auth_service_locator.dart';
import 'package:user_servicehub/data/logic/services/discovery_service_locator.dart';
import 'package:user_servicehub/data/logic/services/favourite_service_locator.dart';
import 'package:user_servicehub/data/logic/services/package_service_locator.dart';
import 'package:user_servicehub/data/logic/services/profile_service_locator.dart';
import 'package:user_servicehub/data/logic/services/review_service_locator.dart';

GetIt getIt = GetIt.instance;

class ServiceLocator {
  static void setup() {
    // dio client
    getIt.registerSingleton(Dio());
    getIt.registerSingleton(DioClient(getIt<Dio>()));

    // Services
    getIt.registerSingleton(AuthServices());
    getIt.registerSingleton(DiscoveryService());
    getIt.registerSingleton(PackageService());
    getIt.registerSingleton(AddressService());
    getIt.registerSingleton(ReviewService());
    getIt.registerSingleton(ProfileService());
    getIt.registerSingleton(FavouriteService());

    // Repos
    getIt.registerSingleton(AuthRepo(getIt<AuthServices>()));
    getIt.registerSingleton(DiscoveryRepo(getIt<DiscoveryService>()));
    getIt.registerSingleton(PackageRepo(getIt<PackageService>()));
    getIt.registerSingleton(AddressRepo(getIt<AddressService>()));
    getIt.registerSingleton(ReviewRepo(getIt<ReviewService>()));
    getIt.registerSingleton(ProfileRepo(getIt<ProfileService>()));
    getIt.registerSingleton(FavouriteRepo(getIt<FavouriteService>()));
  }
}
