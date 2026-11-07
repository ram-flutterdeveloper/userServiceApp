// import 'dart:convert';
// import 'package:user_servicehub/data/models/user_address_model.dart';

// MyBookingResponse myBookingResponseFromJson(String str) =>
//     MyBookingResponse.fromJson(json.decode(str));

// BookingDetailsResponse bookingDetailsResponseFromJson(String str) =>
//     BookingDetailsResponse.fromJson(json.decode(str));

// String myBookingResponseToJson(MyBookingResponse data) =>
//     json.encode(data.toJson());

// class MyBookingResponse {
//   final bool success;
//   final String message;
//   final List<BookingData> data;

//   MyBookingResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory MyBookingResponse.fromJson(Map<String, dynamic> json) {
//     return MyBookingResponse(
//       success: json["success"] ?? false,
//       message: json["message"]?.toString() ?? "",
//       data: json["data"] is List
//           ? (json["data"] as List)
//               .map(
//                 (e) => BookingData.fromJson(
//                   Map<String, dynamic>.from(e),
//                 ),
//               )
//               .toList()
//           : [],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "data": data.map((e) => e.toJson()).toList(),
//       };
// }

// class BookingDetailsResponse {
//   final bool success;
//   final String message;
//   final BookingData data;

//   BookingDetailsResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory BookingDetailsResponse.fromJson(Map<String, dynamic> json) {
//     return BookingDetailsResponse(
//       success: json["success"] ?? false,
//       message: json["message"]?.toString() ?? "",
//       data: json["data"] is Map
//           ? BookingData.fromJson(Map<String, dynamic>.from(json["data"]))
//           : BookingData.fromJson({}),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "data": data.toJson(),
//       };
// } 

// class BookingData {
//   final String id;
//   final String bookingNumber;
//   final String userId;

//   final String? providerId;
//   final String? packageId;
//   final String? addressId;

//   final DateTime? bookingDate;
//   final String bookingTime;

//   final String status;
//   final String paymentMethod;
//   final String paymentStatus;

//   final String subtotal;
//   final String discount;
//   final String tax;
//   final String extraCharge;
//   final String totalAmount;

//   final String? notes;

//   final String? cancelledReason;
//   final DateTime? cancelledAt;

//   final String? assignedBy;
//   final DateTime? assignedAt;
//   final DateTime? assignmentExpiresAt;

//   final DateTime? acceptedAt;
//   final DateTime? rejectedAt;
//   final String? rejectionReason;

//   final DateTime? onTheWayAt;
//   final DateTime? arrivedAt;
//   final DateTime? completedAt;

//   final String? arrivalOtp;
//   final DateTime? arrivalOtpVerifiedAt;

//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final DateTime? deletedAt;

//   final List<BookingItem> items;
//   final ProviderData? provider;

//   final UserAddressModel? address;

//   BookingData({
//     required this.id,
//     required this.bookingNumber,
//     required this.userId,
//     this.providerId,
//     this.packageId,
//     this.addressId,
//     this.bookingDate,
//     required this.bookingTime,
//     required this.status,
//     required this.paymentMethod,
//     required this.paymentStatus,
//     required this.subtotal,
//     required this.discount,
//     required this.tax,
//     required this.extraCharge,
//     required this.totalAmount,
//     this.notes,
//     this.cancelledReason,
//     this.cancelledAt,
//     this.assignedBy,
//     this.assignedAt,
//     this.assignmentExpiresAt,
//     this.acceptedAt,
//     this.rejectedAt,
//     this.rejectionReason,
//     this.onTheWayAt,
//     this.arrivedAt,
//     this.completedAt,
//     this.arrivalOtp,
//     this.arrivalOtpVerifiedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     required this.items,
//     this.provider,
//     this.address,
//   });

//   factory BookingData.fromJson(Map<String, dynamic> json) {
//     return BookingData(
//       id: json["id"]?.toString() ?? "",
//       bookingNumber: json["bookingNumber"]?.toString() ?? "",
//       userId: json["userId"]?.toString() ?? "",

//       providerId: json["providerId"]?.toString(),
//       packageId: json["packageId"]?.toString(),
//       addressId: json["addressId"]?.toString(),

//       bookingDate: _parseDate(json["bookingDate"]),
//       bookingTime: json["bookingTime"]?.toString() ?? "",

//       status: json["status"]?.toString() ?? "",
//       paymentMethod: json["paymentMethod"]?.toString() ?? "",
//       paymentStatus: json["paymentStatus"]?.toString() ?? "",

//       subtotal: json["subtotal"]?.toString() ?? "0",
//       discount: json["discount"]?.toString() ?? "0",
//       tax: json["tax"]?.toString() ?? "0",
//       extraCharge: json["extraCharge"]?.toString() ?? "0",
//       totalAmount: json["totalAmount"]?.toString() ?? "0",

//       notes: json["notes"]?.toString(),

//       cancelledReason: json["cancelledReason"]?.toString(),
//       cancelledAt: _parseDate(json["cancelledAt"]),

//       assignedBy: json["assignedBy"]?.toString(),
//       assignedAt: _parseDate(json["assignedAt"]),
//       assignmentExpiresAt:
//           _parseDate(json["assignmentExpiresAt"]),

//       acceptedAt: _parseDate(json["acceptedAt"]),
//       rejectedAt: _parseDate(json["rejectedAt"]),
//       rejectionReason: json["rejectionReason"]?.toString(),

//       onTheWayAt: _parseDate(json["onTheWayAt"]),
//       arrivedAt: _parseDate(json["arrivedAt"]),
//       completedAt: _parseDate(json["completedAt"]),

//       arrivalOtp: json["arrivalOtp"]?.toString(),
//       arrivalOtpVerifiedAt:
//           _parseDate(json["arrivalOtpVerifiedAt"]),

//       createdAt: _parseDate(json["createdAt"]),
//       updatedAt: _parseDate(json["updatedAt"]),
//       deletedAt: _parseDate(json["deletedAt"]),

//       items: json["items"] is List
//           ? (json["items"] as List)
//               .map(
//                 (e) => BookingItem.fromJson(
//                   Map<String, dynamic>.from(e),
//                 ),
//               )
//               .toList()
//           : [],

//       provider: json["provider"] is Map
//           ? ProviderData.fromJson(
//               Map<String, dynamic>.from(json["provider"]),
//             )
//           : null,
//       address: json["address"] is Map
//           ? UserAddressModel.fromJson(
//               Map<String, dynamic>.from(json["address"]),
//             )
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "bookingNumber": bookingNumber,
//         "userId": userId,
//         "providerId": providerId,
//         "packageId": packageId,
//         "addressId": addressId,
//         "bookingDate": bookingDate?.toIso8601String(),
//         "bookingTime": bookingTime,
//         "status": status,
//         "paymentMethod": paymentMethod,
//         "paymentStatus": paymentStatus,
//         "subtotal": subtotal,
//         "discount": discount,
//         "tax": tax,
//         "extraCharge": extraCharge,
//         "totalAmount": totalAmount,
//         "notes": notes,
//         "cancelledReason": cancelledReason,
//         "cancelledAt": cancelledAt?.toIso8601String(),
//         "assignedBy": assignedBy,
//         "assignedAt": assignedAt?.toIso8601String(),
//         "assignmentExpiresAt":
//             assignmentExpiresAt?.toIso8601String(),
//         "acceptedAt": acceptedAt?.toIso8601String(),
//         "rejectedAt": rejectedAt?.toIso8601String(),
//         "rejectionReason": rejectionReason,
//         "onTheWayAt": onTheWayAt?.toIso8601String(),
//         "arrivedAt": arrivedAt?.toIso8601String(),
//         "completedAt": completedAt?.toIso8601String(),
//         "arrivalOtp": arrivalOtp,
//         "arrivalOtpVerifiedAt":
//             arrivalOtpVerifiedAt?.toIso8601String(),
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "deletedAt": deletedAt?.toIso8601String(),
//         "items": items.map((e) => e.toJson()).toList(),
//         "provider": provider?.toJson(),
//         "address": address?.toJson(),
//       };
// }

// class BookingItem {
//   final String id;
//   final String bookingId;

//   final String categoryId;
//   final String? subCategoryId;

//   final String serviceId;
//   final String packageId;

//   final String packageName;
//   final String packageDescription;

//   final int duration;
//   final int quantity;

//   final String unitPrice;
//   final String discount;
//   final String tax;
//   final String totalPrice;

//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final DateTime? deletedAt;

//   final PackageData? package;

//   BookingItem({
//     required this.id,
//     required this.bookingId,
//     required this.categoryId,
//     this.subCategoryId,
//     required this.serviceId,
//     required this.packageId,
//     required this.packageName,
//     required this.packageDescription,
//     required this.duration,
//     required this.quantity,
//     required this.unitPrice,
//     required this.discount,
//     required this.tax,
//     required this.totalPrice,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.package,
//   });

//   factory BookingItem.fromJson(Map<String, dynamic> json) {
//     return BookingItem(
//       id: json["id"]?.toString() ?? "",
//       bookingId: json["bookingId"]?.toString() ?? "",

//       categoryId: json["categoryId"]?.toString() ?? "",
//       subCategoryId: json["subCategoryId"]?.toString(),

//       serviceId: json["serviceId"]?.toString() ?? "",
//       packageId: json["packageId"]?.toString() ?? "",

//       packageName: json["packageName"]?.toString() ?? "",
//       packageDescription:
//           json["packageDescription"]?.toString() ?? "",

//       duration: _parseInt(json["duration"]),
//       quantity: _parseInt(json["quantity"]),

//       unitPrice: json["unitPrice"]?.toString() ?? "0",
//       discount: json["discount"]?.toString() ?? "0",
//       tax: json["tax"]?.toString() ?? "0",
//       totalPrice: json["totalPrice"]?.toString() ?? "0",

//       createdAt: _parseDate(json["createdAt"]),
//       updatedAt: _parseDate(json["updatedAt"]),
//       deletedAt: _parseDate(json["deletedAt"]),

//       package: json["package"] is Map
//           ? PackageData.fromJson(
//               Map<String, dynamic>.from(json["package"]),
//             )
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "bookingId": bookingId,
//         "categoryId": categoryId,
//         "subCategoryId": subCategoryId,
//         "serviceId": serviceId,
//         "packageId": packageId,
//         "packageName": packageName,
//         "packageDescription": packageDescription,
//         "duration": duration,
//         "quantity": quantity,
//         "unitPrice": unitPrice,
//         "discount": discount,
//         "tax": tax,
//         "totalPrice": totalPrice,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "deletedAt": deletedAt?.toIso8601String(),
//         "package": package?.toJson(),
//       };
// }

// class PackageData {
//   final String id;
//   final String? subCategoryId;

//   final String name;
//   final String slug;
//   final String description;

//   final String? image;

//   final String defaultPrice;
//   final String offerPrice;

//   final int durationMinutes;
//   final int sortOrder;

//   final bool isFeatured;

//   final String status;
//   final String serviceId;

//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final DateTime? deletedAt;

//   PackageData({
//     required this.id,
//     this.subCategoryId,
//     required this.name,
//     required this.slug,
//     required this.description,
//     this.image,
//     required this.defaultPrice,
//     required this.offerPrice,
//     required this.durationMinutes,
//     required this.sortOrder,
//     required this.isFeatured,
//     required this.status,
//     required this.serviceId,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//   });

//   factory PackageData.fromJson(Map<String, dynamic> json) {
//     return PackageData(
//       id: json["id"]?.toString() ?? "",
//       subCategoryId: json["subCategoryId"]?.toString(),

//       name: json["name"]?.toString() ?? "",
//       slug: json["slug"]?.toString() ?? "",
//       description: json["description"]?.toString() ?? "",

//       image: json["image"]?.toString(),

//       defaultPrice: json["defaultPrice"]?.toString() ?? "0",
//       offerPrice: json["offerPrice"]?.toString() ?? "0",

//       durationMinutes:
//           _parseInt(json["durationMinutes"]),
//       sortOrder: _parseInt(json["sortOrder"]),

//       isFeatured: _parseBool(json["isFeatured"]),

//       status: json["status"]?.toString() ?? "",
//       serviceId: json["serviceId"]?.toString() ?? "",

//       createdAt: _parseDate(json["createdAt"]),
//       updatedAt: _parseDate(json["updatedAt"]),
//       deletedAt: _parseDate(json["deletedAt"]),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "subCategoryId": subCategoryId,
//         "name": name,
//         "slug": slug,
//         "description": description,
//         "image": image,
//         "defaultPrice": defaultPrice,
//         "offerPrice": offerPrice,
//         "durationMinutes": durationMinutes,
//         "sortOrder": sortOrder,
//         "isFeatured": isFeatured,
//         "status": status,
//         "serviceId": serviceId,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "deletedAt": deletedAt?.toIso8601String(),
//       };
// }

// class ProviderData {
//   final String id;
//   final String userId;

//   final String businessName;
//   final String ownerName;

//   final String email;
//   final String phone;

//   final int experience;

//   final String description;
//   final String? profileImage;

//   final bool isVerified;
//   final String status;

//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final DateTime? deletedAt;

//   ProviderData({
//     required this.id,
//     required this.userId,
//     required this.businessName,
//     required this.ownerName,
//     required this.email,
//     required this.phone,
//     required this.experience,
//     required this.description,
//     this.profileImage,
//     required this.isVerified,
//     required this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//   });

//   factory ProviderData.fromJson(Map<String, dynamic> json) {
//     return ProviderData(
//       id: json["id"]?.toString() ?? "",
//       userId: json["userId"]?.toString() ?? "",

//       businessName: json["businessName"]?.toString() ?? "",
//       ownerName: json["ownerName"]?.toString() ?? "",

//       email: json["email"]?.toString() ?? "",
//       phone: json["phone"]?.toString() ?? "",

//       experience: _parseInt(json["experience"]),

//       description: json["description"]?.toString() ?? "",
//       profileImage: json["profileImage"]?.toString(),

//       isVerified: _parseBool(json["isVerified"]),
//       status: json["status"]?.toString() ?? "",

//       createdAt: _parseDate(json["createdAt"]),
//       updatedAt: _parseDate(json["updatedAt"]),
//       deletedAt: _parseDate(json["deletedAt"]),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "userId": userId,
//         "businessName": businessName,
//         "ownerName": ownerName,
//         "email": email,
//         "phone": phone,
//         "experience": experience,
//         "description": description,
//         "profileImage": profileImage,
//         "isVerified": isVerified,
//         "status": status,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "deletedAt": deletedAt?.toIso8601String(),
//       };
// }


// /// Safe date parser
// DateTime? _parseDate(dynamic value) {
//   if (value == null) return null;

//   final text = value.toString().trim();

//   if (text.isEmpty) return null;

//   return DateTime.tryParse(text);
// }

// /// Handles int / double / String safely
// int _parseInt(dynamic value) {
//   if (value == null) return 0;

//   if (value is int) {
//     return value;
//   }

//   if (value is double) {
//     return value.toInt();
//   }

//   return int.tryParse(value.toString()) ??
//       double.tryParse(value.toString())?.toInt() ??
//       0;
// }

// /// Handles bool / String / int safely
// bool _parseBool(dynamic value) {
//   if (value is bool) return value;

//   if (value is num) {
//     return value != 0;
//   }

//   final text = value?.toString().toLowerCase();

//   return text == "true" || text == "1";
// }



import 'dart:convert';

import 'package:user_servicehub/data/models/user_address_model.dart';

BookingHistoryResponse bookingHistoryResponseFromJson(String source) {
  return BookingHistoryResponse.fromJson(
    jsonDecode(source) as Map<String, dynamic>,
  );
}

String bookingHistoryResponseToJson(BookingHistoryResponse response) {
  return jsonEncode(response.toJson());
}

class BookingHistoryResponse {
  final bool success;
  final String message;
  final List<BookingHistoryItem> bookings;
  final BookingPagination pagination;

  const BookingHistoryResponse({
    required this.success,
    required this.message,
    required this.bookings,
    required this.pagination,
  });

  factory BookingHistoryResponse.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    final paginationJson = _asMap(data['pagination']);
    final bookingList = data['bookings'];

    return BookingHistoryResponse(
      success: json['success'] == true,
      message: _string(json['message']),
      bookings: bookingList is List
          ? bookingList
              .whereType<Map>()
              .map(
                (item) => BookingHistoryItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : <BookingHistoryItem>[],
      pagination: BookingPagination.fromJson(paginationJson),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': {
          'bookings': bookings.map((item) => item.toJson()).toList(),
          'pagination': pagination.toJson(),
        },
      };
}

class BookingPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const BookingPagination({
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  factory BookingPagination.fromJson(Map<String, dynamic> json) {
    return BookingPagination(
      page: _int(json['page'], fallback: 1),
      limit: _int(json['limit'], fallback: 10),
      total: _int(json['total']),
      totalPages: _int(json['totalPages']),
      hasNextPage: _bool(json['hasNextPage']),
      hasPreviousPage: _bool(json['hasPreviousPage']),
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'totalPages': totalPages,
        'hasNextPage': hasNextPage,
        'hasPreviousPage': hasPreviousPage,
      };
}

class BookingHistoryItem {
  final String id;
  final String bookingNumber;
  final String userId;
  final String? providerId;
  final String? packageId;
  final String? addressId;

  final DateTime? bookingDate;
  final String bookingTime;
  final String status;

  final String paymentMethod;
  final String paymentStatus;

  final String subtotal;
  final String discount;
  final String tax;
  final String extraCharge;
  final String totalAmount;

  final String? notes;
  final String? cancelledReason;
  final DateTime? cancelledAt;

  final String? assignedBy;
  final DateTime? assignedAt;
  final DateTime? assignmentExpiresAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final DateTime? onTheWayAt;
  final DateTime? arrivedAt;
  final DateTime? completedAt;

  final String? arrivalOtp;
  final DateTime? arrivalOtpVerifiedAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  final List<BookingHistoryLineItem> items;
  final BookingProvider? provider;
  final UserAddressModel? address;

  const BookingHistoryItem({
    required this.id,
    required this.bookingNumber,
    required this.userId,
    this.providerId,
    this.packageId,
    this.addressId,
    this.bookingDate,
    required this.bookingTime,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.extraCharge,
    required this.totalAmount,
    this.notes,
    this.cancelledReason,
    this.cancelledAt,
    this.assignedBy,
    this.assignedAt,
    this.assignmentExpiresAt,
    this.acceptedAt,
    this.rejectedAt,
    this.rejectionReason,
    this.onTheWayAt,
    this.arrivedAt,
    this.completedAt,
    this.arrivalOtp,
    this.arrivalOtpVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.items = const [],
    this.provider,
    this.address,
  });

  factory BookingHistoryItem.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return BookingHistoryItem(
      id: _string(json['id']),
      bookingNumber: _string(json['bookingNumber']),
      userId: _string(json['userId']),
      providerId: _nullableString(json['providerId']),
      packageId: _nullableString(json['packageId']),
      addressId: _nullableString(json['addressId']),
      bookingDate: _date(json['bookingDate']),
      bookingTime: _string(json['bookingTime']),
      status: _string(json['status']),
      paymentMethod: _string(json['paymentMethod']),
      paymentStatus: _string(json['paymentStatus']),
      subtotal: _string(json['subtotal'], fallback: '0'),
      discount: _string(json['discount'], fallback: '0'),
      tax: _string(json['tax'], fallback: '0'),
      extraCharge: _string(json['extraCharge'], fallback: '0'),
      totalAmount: _string(json['totalAmount'], fallback: '0'),
      notes: _nullableString(json['notes']),
      cancelledReason: _nullableString(json['cancelledReason']),
      cancelledAt: _date(json['cancelledAt']),
      assignedBy: _nullableString(json['assignedBy']),
      assignedAt: _date(json['assignedAt']),
      assignmentExpiresAt: _date(json['assignmentExpiresAt']),
      acceptedAt: _date(json['acceptedAt']),
      rejectedAt: _date(json['rejectedAt']),
      rejectionReason: _nullableString(json['rejectionReason']),
      onTheWayAt: _date(json['onTheWayAt']),
      arrivedAt: _date(json['arrivedAt']),
      completedAt: _date(json['completedAt']),
      arrivalOtp: _nullableString(json['arrivalOtp']),
      arrivalOtpVerifiedAt: _date(json['arrivalOtpVerifiedAt']),
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
      deletedAt: _date(json['deletedAt']),
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map(
                (item) => BookingHistoryLineItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : <BookingHistoryLineItem>[],
      provider: json['provider'] is Map
          ? BookingProvider.fromJson(_asMap(json['provider']))
          : null,
      address: json['address'] is Map
          ? UserAddressModel.fromJson(_asMap(json['address']))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingNumber': bookingNumber,
        'userId': userId,
        'providerId': providerId,
        'packageId': packageId,
        'addressId': addressId,
        'bookingDate': _dateString(bookingDate),
        'bookingTime': bookingTime,
        'status': status,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'subtotal': subtotal,
        'discount': discount,
        'tax': tax,
        'extraCharge': extraCharge,
        'totalAmount': totalAmount,
        'notes': notes,
        'cancelledReason': cancelledReason,
        'cancelledAt': _dateString(cancelledAt),
        'assignedBy': assignedBy,
        'assignedAt': _dateString(assignedAt),
        'assignmentExpiresAt': _dateString(assignmentExpiresAt),
        'acceptedAt': _dateString(acceptedAt),
        'rejectedAt': _dateString(rejectedAt),
        'rejectionReason': rejectionReason,
        'onTheWayAt': _dateString(onTheWayAt),
        'arrivedAt': _dateString(arrivedAt),
        'completedAt': _dateString(completedAt),
        'arrivalOtp': arrivalOtp,
        'arrivalOtpVerifiedAt': _dateString(arrivalOtpVerifiedAt),
        'createdAt': _dateString(createdAt),
        'updatedAt': _dateString(updatedAt),
        'deletedAt': _dateString(deletedAt),
        'items': items.map((item) => item.toJson()).toList(),
        'provider': provider?.toJson(),
        'address': address?.toJson(),
      };
}

class BookingHistoryLineItem {
  final String id;
  final String bookingId;
  final String categoryId;
  final String? subCategoryId;
  final String serviceId;
  final String packageId;

  final String packageName;
  final String packageDescription;
  final int duration;
  final int quantity;

  final String unitPrice;
  final String discount;
  final String tax;
  final String totalPrice;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  final BookingPackage? package;

  const BookingHistoryLineItem({
    required this.id,
    required this.bookingId,
    required this.categoryId,
    this.subCategoryId,
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
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.package,
  });

  factory BookingHistoryLineItem.fromJson(Map<String, dynamic> json) {
    return BookingHistoryLineItem(
      id: _string(json['id']),
      bookingId: _string(json['bookingId']),
      categoryId: _string(json['categoryId']),
      subCategoryId: _nullableString(json['subCategoryId']),
      serviceId: _string(json['serviceId']),
      packageId: _string(json['packageId']),
      packageName: _string(json['packageName']),
      packageDescription: _string(json['packageDescription']),
      duration: _int(json['duration']),
      quantity: _int(json['quantity']),
      unitPrice: _string(json['unitPrice'], fallback: '0'),
      discount: _string(json['discount'], fallback: '0'),
      tax: _string(json['tax'], fallback: '0'),
      totalPrice: _string(json['totalPrice'], fallback: '0'),
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
      deletedAt: _date(json['deletedAt']),
      package: json['package'] is Map
          ? BookingPackage.fromJson(_asMap(json['package']))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingId': bookingId,
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
        'serviceId': serviceId,
        'packageId': packageId,
        'packageName': packageName,
        'packageDescription': packageDescription,
        'duration': duration,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'discount': discount,
        'tax': tax,
        'totalPrice': totalPrice,
        'createdAt': _dateString(createdAt),
        'updatedAt': _dateString(updatedAt),
        'deletedAt': _dateString(deletedAt),
        'package': package?.toJson(),
      };
}

class BookingPackage {
  final String id;
  final String? subCategoryId;
  final String name;
  final String slug;
  final String description;
  final String? image;
  final String defaultPrice;
  final String offerPrice;
  final int durationMinutes;
  final int sortOrder;
  final bool isFeatured;
  final String status;
  final String serviceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const BookingPackage({
    required this.id,
    this.subCategoryId,
    required this.name,
    required this.slug,
    required this.description,
    this.image,
    required this.defaultPrice,
    required this.offerPrice,
    required this.durationMinutes,
    required this.sortOrder,
    required this.isFeatured,
    required this.status,
    required this.serviceId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BookingPackage.fromJson(Map<String, dynamic> json) {
    return BookingPackage(
      id: _string(json['id']),
      subCategoryId: _nullableString(json['subCategoryId']),
      name: _string(json['name']),
      slug: _string(json['slug']),
      description: _string(json['description']),
      image: _nullableString(json['image']),
      defaultPrice: _string(json['defaultPrice'], fallback: '0'),
      offerPrice: _string(json['offerPrice'], fallback: '0'),
      durationMinutes: _int(json['durationMinutes']),
      sortOrder: _int(json['sortOrder']),
      isFeatured: _bool(json['isFeatured']),
      status: _string(json['status']),
      serviceId: _string(json['serviceId']),
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
      deletedAt: _date(json['deletedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subCategoryId': subCategoryId,
        'name': name,
        'slug': slug,
        'description': description,
        'image': image,
        'defaultPrice': defaultPrice,
        'offerPrice': offerPrice,
        'durationMinutes': durationMinutes,
        'sortOrder': sortOrder,
        'isFeatured': isFeatured,
        'status': status,
        'serviceId': serviceId,
        'createdAt': _dateString(createdAt),
        'updatedAt': _dateString(updatedAt),
        'deletedAt': _dateString(deletedAt),
      };
}

class BookingProvider {
  final String id;
  final String userId;
  final String businessName;
  final String ownerName;
  final String email;
  final String phone;
  final int experience;
  final String description;
  final String? profileImage;
  final bool isVerified;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const BookingProvider({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.experience,
    required this.description,
    this.profileImage,
    required this.isVerified,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BookingProvider.fromJson(Map<String, dynamic> json) {
    return BookingProvider(
      id: _string(json['id']),
      userId: _string(json['userId']),
      businessName: _string(json['businessName']),
      ownerName: _string(json['ownerName']),
      email: _string(json['email']),
      phone: _string(json['phone']),
      experience: _int(json['experience']),
      description: _string(json['description']),
      profileImage: _nullableString(json['profileImage']),
      isVerified: _bool(json['isVerified']),
      status: _string(json['status']),
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
      deletedAt: _date(json['deletedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'businessName': businessName,
        'ownerName': ownerName,
        'email': email,
        'phone': phone,
        'experience': experience,
        'description': description,
        'profileImage': profileImage,
        'isVerified': isVerified,
        'status': status,
        'createdAt': _dateString(createdAt),
        'updatedAt': _dateString(updatedAt),
        'deletedAt': _dateString(deletedAt),
      };
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

String _string(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}

String? _nullableString(dynamic value) {
  if (value == null) return null;
  final result = value.toString();
  return result.isEmpty ? null : result;
}

DateTime? _date(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

String? _dateString(DateTime? value) => value?.toIso8601String();

int _int(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();

  final text = value?.toString();
  if (text == null) return fallback;

  return int.tryParse(text) ??
      double.tryParse(text)?.toInt() ??
      fallback;
}

bool _bool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;

  final text = value?.toString().toLowerCase();
  return text == 'true' || text == '1';
}
