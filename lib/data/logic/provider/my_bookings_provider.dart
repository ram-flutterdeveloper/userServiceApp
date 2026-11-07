// import 'package:flutter/material.dart';
// import 'package:user_servicehub/core/network_services/service_locator.dart';
// import 'package:user_servicehub/data/logic/repo/package_repo.dart';
// import 'package:user_servicehub/data/models/MyBookingResponse.dart';
// import 'package:user_servicehub/data/models/booking_model.dart';

// class MyBookingsProvider with ChangeNotifier {
//   final _packageRepo = getIt<PackageRepo>();

//   bool _isLoading = false;
//   String? _error;
//   List<BookingModel> _bookings = [];

//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   List<BookingModel> get bookings => _bookings;

//   Future<void> fetchBookings() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     final result = await _packageRepo.getMyBookings();

//     if (result.isLeft()) {
//       _isLoading = false;
//       _error = result.getLeft().toNullable()?.message ?? 'Failed to load bookings';
//       notifyListeners();
//       return;
//     }

//     try {
//       final response = result.getRight().toNullable();
//       final model = myBookingResponseFromJson(response.toString());
//       _bookings = model.data.map(_toBookingModel).toList();
//       _isLoading = false;
//     } catch (e) {
//       _isLoading = false;
//       _error = 'Failed to parse bookings';
//       debugPrint('Error parsing my bookings: $e');
//     }
//     notifyListeners();
//   }

//   void clear() {
//     _bookings = [];
//     _error = null;
//     _isLoading = false;
//     notifyListeners();
//   }

//   void updateBookingStatus(String bookingId, String status) {
//     final index = _bookings.indexWhere((b) => b.id == bookingId);
//     if (index == -1) return;
//     _bookings[index] = _bookings[index].copyWith(status: status);
//     notifyListeners();
//   }

//   void restoreBooking(BookingModel booking) {
//     final index = _bookings.indexWhere((b) => b.id == booking.id);
//     if (index == -1) return;
//     _bookings[index] = booking;
//     notifyListeners();
//   }

//   BookingModel _toBookingModel(BookingData b) {
//     final provider = b.provider;
//     final item = b.items.isNotEmpty ? b.items.first : null;

//     return BookingModel(
//       id: b.id,
//       serviceId: item?.serviceId ?? '',
//       serviceName: item?.packageName ?? b.bookingNumber,
//       serviceImage: item?.package?.image ?? '',
//       providerName: provider?.businessName ?? provider?.ownerName ?? '',
//       providerId: provider?.id ?? b.providerId ?? '',
//       providerPhone: provider?.phone ?? '',
//       date: b.bookingDate?.toIso8601String().split('T').first ?? '',
//       timeSlot: b.bookingTime,
//       address: '',
//       status: _mapStatus(b.status),
//       totalAmount: double.tryParse(b.totalAmount) ?? 0,
//       paymentMethod: b.paymentMethod,
//       couponApplied: (double.tryParse(b.discount) ?? 0) > 0 ? 'Applied' : null,
//       specialInstructions: b.notes,
//     );
//   }

//   String _mapStatus(String status) {
//     switch (status.toUpperCase()) {
//       case 'PENDING':
//       case 'CONFIRMED':
//         return 'upcoming';
//       case 'ONGOING':
//       case 'IN_PROGRESS':
//       case 'STARTED':
//         return 'active';
//       case 'COMPLETED':
//       case 'DONE':
//         return 'completed';
//       case 'CANCELLED':
//       case 'CANCELED':
//       case 'REJECTED':
//         return 'cancelled';
//       default:
//         return status.toLowerCase();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/package_repo.dart';
import 'package:user_servicehub/data/models/MyBookingResponse.dart';

class MyBookingsProvider with ChangeNotifier {
  final PackageRepo _packageRepo = getIt<PackageRepo>();

  static const int pageSize = 10;

  List<BookingHistoryItem> _bookings = [];

  BookingPagination _pagination = const BookingPagination();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  String _status = 'bookings';

  // Used to ignore old responses when the user switches tabs quickly.
  int _requestId = 0;

  // Getters
  List<BookingHistoryItem> get bookings => List.unmodifiable(_bookings);

  BookingPagination get pagination => _pagination;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  String? get error => _error;

  String get status => _status;

  bool get hasNextPage => _pagination.hasNextPage;

  int get currentPage => _pagination.page;

  int get totalBookings => _pagination.total;

  // Fetch first page for the selected backend filter.
  Future<void> fetchBookings({String? status}) async {
    final requestId = ++_requestId;

    _status = status ?? _status;
    _bookings = [];
    _pagination = const BookingPagination();
    _error = null;
    _isLoading = true;
    _isLoadingMore = false;

    notifyListeners();

    await _fetchPage(page: 1, requestId: requestId, append: false);
  }

  // Load the next page from the backend.
  Future<void> loadNextPage() async {
    if (_isLoading || _isLoadingMore || !_pagination.hasNextPage) {
      return;
    }

    final requestId = _requestId;

    await _fetchPage(
      page: _pagination.page + 1,
      requestId: requestId,
      append: true,
    );
  }

  // Shared API request logic.
  Future<void> _fetchPage({
    required int page,
    required int requestId,
    required bool append,
  }) async {
    if (append) {
      _isLoadingMore = true;
    } else {
      _isLoading = true;
    }

    _error = null;
    notifyListeners();

    try {
      final body = {'page': page, 'limit': pageSize, 'status': _status};
      final result = await _packageRepo.getMyBookings(body);

      // Ignore responses belonging to a previous tab/request.
      if (requestId != _requestId) return;

      if (result.isLeft()) {
        _error =
            result.getLeft().toNullable()?.message ?? 'Failed to load bookings';
        return;
      }

      final response = result.getRight().toNullable();

      if (response == null) {
        _error = 'The server returned an empty response';
        return;
      }

      final model = bookingHistoryResponseFromJson(response.toString());

      if (!model.success) {
        _error =
            model.message.isNotEmpty
                ? model.message
                : 'Failed to load bookings';
        return;
      }

      if (append) {
        // Append the next server page.
        _bookings = [..._bookings, ...model.bookings];
      } else {
        // Replace records when loading a new filter/page.
        _bookings = model.bookings;
      }

      _pagination = model.pagination;
    } catch (e, stackTrace) {
      if (requestId != _requestId) return;

      _error = 'Unable to load bookings. Please try again.';

      debugPrint('Booking history error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (requestId == _requestId) {
        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  // Refresh the currently selected backend filter.
  Future<void> refresh() {
    return fetchBookings(status: _status);
  }

  // Retry the current filter.
  Future<void> retry() {
    return fetchBookings(status: _status);
  }

  // Clear provider data, for example on logout.
  void clear() {
    _requestId++;

    _bookings = [];
    _pagination = const BookingPagination();
    _error = null;
    _isLoading = false;
    _isLoadingMore = false;
    _status = 'bookings';

    notifyListeners();
  }
}
