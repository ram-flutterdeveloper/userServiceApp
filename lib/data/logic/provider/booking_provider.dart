import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/models/booking_response_model.dart';
import 'package:user_servicehub/data/models/timeSlot_response.dart';

import '../repo/package_repo.dart';

class BookingProvider with ChangeNotifier {
  final _packageRepo = getIt<PackageRepo>();
  static const double serviceCharge = 79.0;
  static const double platformFee = 5.0;
  static const double gstRate = 0.18;

  String? _selectedAddressId;
  int? _selectedDateIndex;
  String? _selectedTimeSlot;
  String? _selectedTimeSlotId;
  String? _selectedProfessionalId;
  bool _autoAssignProfessional = true;
  bool _isCouponApplied = false;
  late List<String> _unavailableSlots;

  String? _packageId;
  String? _packageName;
  String? _packagePrice;
  DateTime? _bookingDate;
  BookingData? _createdBooking;

  BookingProvider() {
    _unavailableSlots = _generateUnavailableSlots();
  }

  String? get selectedAddressId => _selectedAddressId;
  int? get selectedDateIndex => _selectedDateIndex;
  String? get selectedTimeSlot => _selectedTimeSlot;
  String? get selectedTimeSlotId => _selectedTimeSlotId;
  String? get selectedProfessionalId => _selectedProfessionalId;
  bool get autoAssignProfessional => _autoAssignProfessional;
  bool get isCouponApplied => _isCouponApplied;
  List<String> get unavailableSlots => _unavailableSlots;
  String? get packageId => _packageId;
  String? get packageName => _packageName;
  String? get packagePrice => _packagePrice;
  DateTime? get bookingDate => _bookingDate;
  BookingData? get createdBooking => _createdBooking;

  double get discount => _isCouponApplied ? serviceCharge * 0.2 : 0.0;
  double get gst => (serviceCharge + platformFee - discount) * gstRate;
  double get total => serviceCharge + platformFee + gst - discount;

  void setPackage({required String id, String? name, String? price}) {
    _packageId = id;
    _packageName = name;
    _packagePrice = price;
    notifyListeners();
  }

  void setSelectedAddress(String? id) {
    _selectedAddressId = id;
    notifyListeners();
  }

  void setSelectedDate(int? index) {
    _selectedDateIndex = index;
    if (index != null) {
      final now = DateTime.now();
      _bookingDate = DateTime(now.year, now.month, now.day + index);
    } else {
      _bookingDate = null;
    }
    notifyListeners();
  }

  void setSelectedTimeSlot(String? slot, {String? slotId}) {
    _selectedTimeSlot = slot;
    _selectedTimeSlotId =
        (slotId != null && slotId.isNotEmpty) ? slotId : _selectedTimeSlotId;
    if (slot == null) _selectedTimeSlotId = null;
    notifyListeners();
  }

  void setAutoAssignProfessional(bool value) {
    _autoAssignProfessional = value;
    notifyListeners();
  }

  void selectProfessional(String? professionalId) {
    _autoAssignProfessional = false;
    _selectedProfessionalId = professionalId;
    notifyListeners();
  }

  void applyCoupon(String code) {
    if (code == 'SAVE20') {
      _isCouponApplied = true;
      notifyListeners();
    }
  }

  void removeCoupon() {
    _isCouponApplied = false;
    notifyListeners();
  }

  bool validateSelections() {
    if (_selectedAddressId == null) return false;
    if (_selectedDateIndex == null) return false;
    if (_selectedTimeSlot == null) return false;
    if (!_autoAssignProfessional && _selectedProfessionalId == null) {
      return false;
    }
    return true;
  }

  List<String> _generateUnavailableSlots() {
    final random = Random(42);
    const allSlots = [
      '9:00 AM - 11:00 AM',
      '11:00 AM - 1:00 PM',
      '1:00 PM - 3:00 PM',
      '3:00 PM - 5:00 PM',
      '5:00 PM - 7:00 PM',
    ];
    return allSlots.where((_) => random.nextDouble() < 0.3).toList();
  }

  List<TimeSlotData> _timeSlotlist = [];

  List<TimeSlotData> get timeSlotlist => _timeSlotlist;

  Future<void> fetchTimeSlot(BuildContext context) async {
    notifyListeners();

    var result = await _packageRepo.timeSlot();

    result.fold(
      (error) {
        debugPrint("Error fetching reviews: $error");
      },
      (response) {
        final timeSlotModel = timeSlotResponseFromJson(response.toString());
        _timeSlotlist = timeSlotModel.data;

        notifyListeners();
      },
    );
  }

  Future<bool> creatBookings(
    BuildContext context, {
    required String paymentMethod,
    String? notes,
  }) async {
    if (_packageId == null ||
        _selectedAddressId == null ||
        _bookingDate == null ||
        _selectedTimeSlotId == null) {
      return false;
    }

    var data = {
      "packageId": _packageId!,
      "addressId": _selectedAddressId!,
      "bookingDate": DateFormat('yyyy-MM-dd').format(_bookingDate!),
      "timeSlotId": _selectedTimeSlotId!,
      "notes": (notes != null && notes.isNotEmpty) ? notes : "",
      "paymentMethod": paymentMethod,
    };

    var result = await _packageRepo.creatBookings(data);

    var success = false;
    result.fold(
      (error) {
        success = false;
        debugPrint("Error creating booking: $error");
      },
      (response) {
        try {
          final model = bookingResponseFromJson(response.toString());
          _createdBooking = model.data;
          success = true;
        } catch (e) {
          success = false;
          debugPrint("Error parsing booking response: $e");
        }
        notifyListeners();
      },
    );
    return success;
  }
}
