// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
    Data? data;
    bool? success;
    dynamic message;
    int? statusCode;
    dynamic errors;

    UserResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
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
    String? accessToken;
    String? refreshToken;
    String? phone;
    String? fullname;
    int? status;
    bool? isverify;
    dynamic  userId;
    String? role;

    Data({
        this.accessToken,
        this.refreshToken,
        this.phone,
        this.fullname,
        this.status,
        this.isverify,
        this.userId,
        this.role,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        phone: json["phone"],
        fullname: json["fullname"],
        status: json["status"],
        isverify: json["isverify"],
        userId: json["userId"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "phone": phone,
        "fullname": fullname,
        "status": status,
        "isverify": isverify,
        "userId": userId,
        "role": role,
    };
}
