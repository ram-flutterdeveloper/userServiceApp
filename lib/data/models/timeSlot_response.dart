
import 'dart:convert';

TimeSlotResponse timeSlotResponseFromJson(String str) => TimeSlotResponse.fromJson(json.decode(str));

String timeSlotResponseToJson(TimeSlotResponse data) => json.encode(data.toJson());

class TimeSlotResponse {
    bool success;
    String message;
    List<TimeSlotData> data;

    TimeSlotResponse({
        required this.success,
        required this.message,
        required this.data,
    });

    factory TimeSlotResponse.fromJson(Map<String, dynamic> json) => TimeSlotResponse(
        success: json["success"],
        message: json["message"],
        data: List<TimeSlotData>.from(json["data"].map((x) => TimeSlotData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class TimeSlotData {
    String id;
    String bookingTime;
    int sortOrder;
    Status status;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    TimeSlotData({
        required this.id,
        required this.bookingTime,
        required this.sortOrder,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory TimeSlotData.fromJson(Map<String, dynamic> json) => TimeSlotData(
        id: json["id"],
        bookingTime: json["bookingTime"],
        sortOrder: json["sortOrder"],
        status: statusValues.map[json["status"]]!,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "bookingTime": bookingTime,
        "sortOrder": sortOrder,
        "status": statusValues.reverse[status],
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt,
    };
}

enum Status {
    ACTIVE
}

final statusValues = EnumValues({
    "ACTIVE": Status.ACTIVE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
