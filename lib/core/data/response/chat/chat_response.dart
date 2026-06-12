// To parse this JSON data, do
//
//     final chatResponse = chatResponseFromJson(jsonString);

import 'dart:convert';

ChatResponse chatResponseFromJson(String str) => ChatResponse.fromJson(json.decode(str));

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {
    List<ChatItemResponse>? data;
    bool? success;
    dynamic message;
    int? statusCode;
    dynamic errors;

    ChatResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        data: json["data"] == null ? [] : List<ChatItemResponse>.from(json["data"]!.map((x) => ChatItemResponse.fromJson(x))),
        success: json["success"],
        message: json["message"],
        statusCode: json["statusCode"],
        errors: json["errors"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "errors": errors,
    };
}

class ChatItemResponse {
    int? id;
    String? senderId;
    String? message;
    DateTime? createdAt;

    ChatItemResponse({
        this.id,
        this.senderId,
        this.message,
        this.createdAt,
    });

    factory ChatItemResponse.fromJson(Map<String, dynamic> json) => ChatItemResponse(
        id: json["id"],
        senderId: json["sender_Id"],
        message: json["message"],
        createdAt: json["created_At"] == null ? null : DateTime.parse(json["created_At"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sender_Id": senderId,
        "message": message,
        "created_At": createdAt?.toIso8601String(),
    };
}
