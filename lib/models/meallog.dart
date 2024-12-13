import 'dart:convert';

MealLog mealLogFromJson(String str) => MealLog.fromJson(json.decode(str));

String mealLogToJson(MealLog data) => json.encode(data.toJson());

class MealLog {
  final Data data;

  MealLog({
    required this.data,
  });

  MealLog copyWith({
    Data? data,
  }) =>
      MealLog(
        data: data ?? this.data,
      );

  factory MealLog.fromJson(Map<String, dynamic> json) => MealLog(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<MealLogElement> mealLogs;
  final Pagination pagination;

  Data({
    required this.mealLogs,
    required this.pagination,
  });

  Data copyWith({
    List<MealLogElement>? mealLogs,
    Pagination? pagination,
  }) =>
      Data(
        mealLogs: mealLogs ?? this.mealLogs,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pagination: Pagination.fromJson(
          json["pagination"],
        ),
        mealLogs: List<MealLogElement>.from(
            json["mealLogs"].map((x) => MealLogElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mealLogs": List<dynamic>.from(mealLogs.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  final int totalCount;
  final int currentPage;
  // final int nextPage;
  // final int previousPage;
  final int totalPages;
  final int perPage;

  Pagination({
    required this.totalCount,
    required this.currentPage,
    // required this.nextPage,
    // required this.previousPage,
    required this.totalPages,
    required this.perPage,
  });

  Pagination copyWith({
    int? totalCount,
    int? currentPage,
    // int? nextPage,
    // int? previousPage,
    int? totalPages,
    int? perPage,
  }) =>
      Pagination(
        totalCount: totalCount ?? this.totalCount,
        currentPage: currentPage ?? this.currentPage,
        // nextPage: nextPage ?? this.nextPage,
        // previousPage: previousPage ?? this.previousPage,
        totalPages: totalPages ?? this.totalPages,
        perPage: perPage ?? this.perPage,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        currentPage: json["current_page"],
        // nextPage: json["next_page"],
        // previousPage: json["previous_page"],
        totalPages: json["total_pages"],
        perPage: json["per_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "current_page": currentPage,
        // "next_page": nextPage,
        // "previous_page": previousPage,
        "total_pages": totalPages,
        "per_page": perPage,
      };
}

class MealLogElement {
  final int id;
  final int userId;
  final String image;
  final bool homeCooked;
  final String note;
  final dynamic type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdAtLabel;
  final String updatedAtLabel;

  MealLogElement({
    required this.id,
    required this.userId,
    required this.image,
    required this.homeCooked,
    required this.note,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.createdAtLabel,
    required this.updatedAtLabel,
  });

  MealLogElement copyWith({
    int? id,
    int? userId,
    String? image,
    bool? homeCooked,
    String? note,
    dynamic type,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdAtLabel,
    String? updatedAtLabel,
  }) =>
      MealLogElement(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        image: image ?? this.image,
        homeCooked: homeCooked ?? this.homeCooked,
        note: note ?? this.note,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAtLabel: createdAtLabel ?? this.createdAtLabel,
        updatedAtLabel: updatedAtLabel ?? this.updatedAtLabel,
      );

  factory MealLogElement.fromJson(Map<String, dynamic> json) => MealLogElement(
        id: json["id"],
        userId: json["userId"],
        image: json["image"],
        homeCooked: json["homeCooked"],
        note: json["note"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAtLabel: json["createdAtLabel"],
        updatedAtLabel: json["updatedAtLabel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "image": image,
        "homeCooked": homeCooked,
        "note": note,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdAtLabel": createdAtLabel,
        "updatedAtLabel": updatedAtLabel,
      };
}
