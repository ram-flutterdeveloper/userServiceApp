import 'dart:convert';

BookingResponse bookingResponseFromJson(String str) =>
    BookingResponse.fromJson(json.decode(str));

String bookingResponseToJson(BookingResponse data) => json.encode(data.toJson());

class BookingResponse {
  bool success;
  String message;
  BookingData data;

  BookingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) => BookingResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: BookingData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class BookingData {
  String id;
  String bookingNumber;
  String userId;
  dynamic providerId;
  String packageId;
  String addressId;
  String bookingDate;
  String bookingTime;
  String status;
  String paymentMethod;
  String paymentStatus;
  String subtotal;
  String discount;
  String tax;
  String extraCharge;
  String totalAmount;
  String notes;
  dynamic cancelledReason;
  dynamic cancelledAt;
  dynamic assignedBy;
  dynamic assignedAt;
  dynamic assignmentExpiresAt;
  dynamic acceptedAt;
  dynamic rejectedAt;
  dynamic rejectionReason;
  dynamic onTheWayAt;
  dynamic arrivedAt;
  dynamic completedAt;
  String arrivalOtp;
  dynamic arrivalOtpVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  List<BookingItem> items;
  List<dynamic> requirements;
  List<BookingStatusLog> statusLogs;

  BookingData({
    required this.id,
    required this.bookingNumber,
    required this.userId,
    required this.providerId,
    required this.packageId,
    required this.addressId,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.extraCharge,
    required this.totalAmount,
    required this.notes,
    required this.cancelledReason,
    required this.cancelledAt,
    required this.assignedBy,
    required this.assignedAt,
    required this.assignmentExpiresAt,
    required this.acceptedAt,
    required this.rejectedAt,
    required this.rejectionReason,
    required this.onTheWayAt,
    required this.arrivedAt,
    required this.completedAt,
    required this.arrivalOtp,
    required this.arrivalOtpVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.items,
    required this.requirements,
    required this.statusLogs,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
        id: json["id"] ?? "",
        bookingNumber: json["bookingNumber"] ?? "",
        userId: json["userId"] ?? "",
        providerId: json["providerId"],
        packageId: json["packageId"] ?? "",
        addressId: json["addressId"] ?? "",
        bookingDate: json["bookingDate"] ?? "",
        bookingTime: json["bookingTime"] ?? "",
        status: json["status"] ?? "",
        paymentMethod: json["paymentMethod"] ?? "",
        paymentStatus: json["paymentStatus"] ?? "",
        subtotal: json["subtotal"] ?? "0.00",
        discount: json["discount"] ?? "0.00",
        tax: json["tax"] ?? "0.00",
        extraCharge: json["extraCharge"] ?? "0.00",
        totalAmount: json["totalAmount"] ?? "0.00",
        notes: json["notes"] ?? "",
        cancelledReason: json["cancelledReason"],
        cancelledAt: json["cancelledAt"],
        assignedBy: json["assignedBy"],
        assignedAt: json["assignedAt"],
        assignmentExpiresAt: json["assignmentExpiresAt"],
        acceptedAt: json["acceptedAt"],
        rejectedAt: json["rejectedAt"],
        rejectionReason: json["rejectionReason"],
        onTheWayAt: json["onTheWayAt"],
        arrivedAt: json["arrivedAt"],
        completedAt: json["completedAt"],
        arrivalOtp: json["arrivalOtp"] ?? "",
        arrivalOtpVerifiedAt: json["arrivalOtpVerifiedAt"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        items: List<BookingItem>.from(
          (json["items"] ?? []).map((x) => BookingItem.fromJson(x)),
        ),
        requirements: List<dynamic>.from(json["requirements"] ?? []),
        statusLogs: List<BookingStatusLog>.from(
          (json["statusLogs"] ?? []).map((x) => BookingStatusLog.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookingNumber": bookingNumber,
        "userId": userId,
        "providerId": providerId,
        "packageId": packageId,
        "addressId": addressId,
        "bookingDate": bookingDate,
        "bookingTime": bookingTime,
        "status": status,
        "paymentMethod": paymentMethod,
        "paymentStatus": paymentStatus,
        "subtotal": subtotal,
        "discount": discount,
        "tax": tax,
        "extraCharge": extraCharge,
        "totalAmount": totalAmount,
        "notes": notes,
        "cancelledReason": cancelledReason,
        "cancelledAt": cancelledAt,
        "assignedBy": assignedBy,
        "assignedAt": assignedAt,
        "assignmentExpiresAt": assignmentExpiresAt,
        "acceptedAt": acceptedAt,
        "rejectedAt": rejectedAt,
        "rejectionReason": rejectionReason,
        "onTheWayAt": onTheWayAt,
        "arrivedAt": arrivedAt,
        "completedAt": completedAt,
        "arrivalOtp": arrivalOtp,
        "arrivalOtpVerifiedAt": arrivalOtpVerifiedAt,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "requirements": requirements,
        "statusLogs": List<dynamic>.from(statusLogs.map((x) => x.toJson())),
      };

  String get packageName =>
      items.isNotEmpty ? items.first.packageName : '';
}

class BookingItem {
  String id;
  String bookingId;
  String categoryId;
  dynamic subCategoryId;
  String serviceId;
  String packageId;
  String packageName;
  String packageDescription;
  int duration;
  int quantity;
  String unitPrice;
  String discount;
  String tax;
  String totalPrice;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  BookingItem({
    required this.id,
    required this.bookingId,
    required this.categoryId,
    required this.subCategoryId,
    required this.serviceId,
    required this.packageId,
    required this.packageName,
    required this.packageDescription,
    required this.duration,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.tax,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
        id: json["id"] ?? "",
        bookingId: json["bookingId"] ?? "",
        categoryId: json["categoryId"] ?? "",
        subCategoryId: json["subCategoryId"],
        serviceId: json["serviceId"] ?? "",
        packageId: json["packageId"] ?? "",
        packageName: json["packageName"] ?? "",
        packageDescription: json["packageDescription"] ?? "",
        duration: json["duration"] ?? 0,
        quantity: json["quantity"] ?? 1,
        unitPrice: json["unitPrice"] ?? "0.00",
        discount: json["discount"] ?? "0.00",
        tax: json["tax"] ?? "0.00",
        totalPrice: json["totalPrice"] ?? "0.00",
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookingId": bookingId,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "serviceId": serviceId,
        "packageId": packageId,
        "packageName": packageName,
        "packageDescription": packageDescription,
        "duration": duration,
        "quantity": quantity,
        "unitPrice": unitPrice,
        "discount": discount,
        "tax": tax,
        "totalPrice": totalPrice,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt,
      };
}

class BookingStatusLog {
  String id;
  String bookingId;
  String status;
  String remarks;
  dynamic updatedBy;
  String updatedByRole;
  DateTime createdAt;

  BookingStatusLog({
    required this.id,
    required this.bookingId,
    required this.status,
    required this.remarks,
    required this.updatedBy,
    required this.updatedByRole,
    required this.createdAt,
  });

  factory BookingStatusLog.fromJson(Map<String, dynamic> json) =>
      BookingStatusLog(
        id: json["id"] ?? "",
        bookingId: json["bookingId"] ?? "",
        status: json["status"] ?? "",
        remarks: json["remarks"] ?? "",
        updatedBy: json["updatedBy"],
        updatedByRole: json["updatedByRole"] ?? "",
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookingId": bookingId,
        "status": status,
        "remarks": remarks,
        "updatedBy": updatedBy,
        "updatedByRole": updatedByRole,
        "createdAt": createdAt.toIso8601String(),
      };
}
