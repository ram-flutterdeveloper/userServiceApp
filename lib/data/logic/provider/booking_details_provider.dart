
import 'package:flutter/material.dart';

import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/package_repo.dart';
import 'package:user_servicehub/data/models/MyBookingResponse.dart';

import 'package:user_servicehub/data/models/booking_details_response.dart';

class BookingDetailsProvider with ChangeNotifier {
  final PackageRepo _packageRepo = getIt<PackageRepo>();

  bool _isLoading = false;
  bool _isCancelling = false;

  String? _error;
  BookingHistoryItem? _booking;

  bool get isLoading => _isLoading;
  bool get isCancelling => _isCancelling;
  String? get error => _error;
  BookingHistoryItem? get booking => _booking;

  Future<void> fetchBooking(
    String id, {
    bool refresh = false,
  }) async {
    if (_isLoading) return;

    if (!refresh && _booking?.id == id) {
      return;
    }

    _isLoading = true;
    _error = null;

    if (refresh || _booking?.id != id) {
      _booking = null;
    }

    notifyListeners();

    try {
      final result = await _packageRepo.getBookingById(id);

      if (result.isLeft()) {
        _error = result.getLeft().toNullable()?.message ??
            'Failed to load booking details';
        return;
      }

      final response = result.getRight().toNullable();

      if (response == null) {
        _error = 'The booking API returned an empty response';
        return;
      }

      final model = BookingDetailsResponse.fromString(
        response.toString(),
      );

      if (!model.success) {
        _error = model.message.isNotEmpty
            ? model.message
            : 'Failed to load booking details';
        return;
      }

      _booking = model.data;
    } catch (e, stackTrace) {
      _error = 'Failed to parse booking details';

      debugPrint('Booking details error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    if (_isCancelling) return false;

    _isCancelling = true;
    _error = null;
    notifyListeners();

    try {
      final payload = <String, dynamic>{};

      if (reason != null && reason.trim().isNotEmpty) {
        payload['reason'] = reason.trim();
      }

      final result = await _packageRepo.cancelBooking(
        bookingId,
        payload,
      );

      if (result.isLeft()) {
        _error = result.getLeft().toNullable()?.message ??
            'Failed to cancel booking';
        return false;
      }

      // Refresh the details after successful cancellation.
      await fetchBooking(bookingId, refresh: true);

      return true;
    } catch (e) {
      _error = 'Failed to cancel booking: $e';
      debugPrint('Cancel booking error: $e');
      return false;
    } finally {
      _isCancelling = false;
      notifyListeners();
    }
  }

  void clear() {
    _booking = null;
    _error = null;
    _isLoading = false;
    _isCancelling = false;
    notifyListeners();
  }
}
