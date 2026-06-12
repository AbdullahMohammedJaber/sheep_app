// To parse this JSON data, do
//
//     final liveResponse = liveResponseFromJson(jsonString);

import 'dart:convert';

LiveResponse liveResponseFromJson(String str) => LiveResponse.fromJson(json.decode(str));

String liveResponseToJson(LiveResponse data) => json.encode(data.toJson());

class LiveResponse {
    Data? data;
    bool? success;
    dynamic message;
    int? statusCode;
    dynamic errors;

    LiveResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory LiveResponse.fromJson(Map<String, dynamic> json) => LiveResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        success: json["success"],
        message: json["message"],
        statusCode: json["statusCode"],
        errors: json["errors"],
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "errors": errors,
    };
}

class Data {
    List<LiveResponseItem>? items;
    int? totalCount;
    int? pageNumber;
    int? pageSize;
    int? totalPages;

    Data({
        this.items,
        this.totalCount,
        this.pageNumber,
        this.pageSize,
        this.totalPages,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["items"] == null ? [] : List<LiveResponseItem>.from(json["items"]!.map((x) => LiveResponseItem.fromJson(x))),
        totalCount: json["totalCount"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "totalCount": totalCount,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalPages": totalPages,
    };
}

class LiveResponseItem {
    int? id;
    String? channelName;
    bool? isActive;
    DateTime? startedAt;
    String? liveName;
    String? liveDescription;
    dynamic sellerName;

    LiveResponseItem({
        this.id,
        this.channelName,
        this.isActive,
        this.startedAt,
        this.liveName,
        this.liveDescription,
        this.sellerName,
    });

    factory LiveResponseItem.fromJson(Map<String, dynamic> json) => LiveResponseItem(
        id: json["id"],
        channelName: json["channel_Name"],
        isActive: json["is_Active"],
        startedAt: json["started_At"] == null ? null : DateTime.parse(json["started_At"]),
        liveName: json["live_Name"],
        liveDescription: json["live_Description"],
        sellerName: json["seller_Name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "channel_Name": channelName,
        "is_Active": isActive,
        "started_At": startedAt?.toIso8601String(),
        "live_Name": liveName,
        "live_Description": liveDescription,
        "seller_Name": sellerName,
    };
}
