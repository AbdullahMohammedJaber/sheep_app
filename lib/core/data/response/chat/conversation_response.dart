// To parse this JSON data, do
//
//     final conversationResponse = conversationResponseFromJson(jsonString);

import 'dart:convert';

ConversationResponse conversationResponseFromJson(String str) => ConversationResponse.fromJson(json.decode(str));

String conversationResponseToJson(ConversationResponse data) => json.encode(data.toJson());

class ConversationResponse {
    List<ConversationItemResponse>? data;
    bool? success;
    dynamic message;
    int? statusCode;
    dynamic errors;

    ConversationResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory ConversationResponse.fromJson(Map<String, dynamic> json) => ConversationResponse(
        data: json["data"] == null ? [] : List<ConversationItemResponse>.from(json["data"]!.map((x) => ConversationItemResponse.fromJson(x))),
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

class ConversationItemResponse {
  int? id;
  dynamic name;
  String? lastMessage;
  DateTime? lastMessageDate;
  num ? un_Read_Messages;
  ConversationItemResponse({
    this.id,
    this.name,
    this.lastMessage,
    this.lastMessageDate,
    this.un_Read_Messages,
  });

  factory ConversationItemResponse.fromJson(Map<String, dynamic> json) {
    final rawDate = json["last_Message_Date"];

    DateTime? parsedDate;

    if (rawDate != null) {
      final normalized =
          rawDate.toString().endsWith('Z') ? rawDate : '${rawDate}Z';

      parsedDate = DateTime.parse(normalized).toLocal();
    }

    return ConversationItemResponse(
      id: json["id"],
      name: json["name"],
      lastMessage: json["last_Message"],
      lastMessageDate: parsedDate,
      un_Read_Messages: json["un_Read_Messages"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "un_Read_Messages": un_Read_Messages,
        "last_Message": lastMessage,
        "last_Message_Date": lastMessageDate?.toUtc().toIso8601String(),
      };
}