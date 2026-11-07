import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_servicehub/core/utils/custom_dio_exception.dart';
import 'package:user_servicehub/core/utils/response_type_def.dart';
import 'package:user_servicehub/data/logic/services/favourite_service_locator.dart';
import 'package:user_servicehub/data/models/favourite_model.dart';
import 'package:user_servicehub/data/models/service_model.dart';

class FavouriteRepo {
  final FavouriteService _favouriteService;

  FavouriteRepo(this._favouriteService);

  FutureResult<List<ServiceModel>> getFavourites() async {
    try {
      var response = await _favouriteService.getFavourites();

      final Map<String, dynamic> data =
          (response.data as Map<String, dynamic>?)?['data']
              as Map<String, dynamic>? ??
              {};

      final List<Favourite> favourites =
          (data['favourites'] as List? ?? [])
              .map((x) => Favourite.fromJson(x as Map<String, dynamic>))
              .toList();

      final List<ServiceModel> services = favourites
          .map((f) => ServiceModel.fromPopularPackage(f.package))
          .toList();

      return right(services);
    } on DioException catch (e) {
      return left(CustomDioExceptions.handleError(e));
    } catch (e) {
      return left(
        CustomError(
          statusCode: 0,
          message: 'Unable to load favourites',
          error: e.toString(),
        ),
      );
    }
  }

  FutureResult<bool> addFavourite(String packageId) async {
    try {
      await _favouriteService.addFavourite(packageId);
      return right(true);
    } on DioException catch (e) {
      return left(CustomDioExceptions.handleError(e));
    } catch (e) {
      return left(
        CustomError(
          statusCode: 0,
          message: 'Failed to add favourite',
          error: e.toString(),
        ),
      );
    }
  }

  FutureResult<bool> removeFavourite(String packageId) async {
    try {
      await _favouriteService.deleteFavourite(packageId);
      return right(true);
    } on DioException catch (e) {
      return left(CustomDioExceptions.handleError(e));
    } catch (e) {
      return left(
        CustomError(
          statusCode: 0,
          message: 'Failed to remove favourite',
          error: e.toString(),
        ),
      );
    }
  }
}