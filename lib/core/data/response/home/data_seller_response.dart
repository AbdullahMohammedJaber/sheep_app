// To parse this JSON data, do
//
//     final dataSellerResponse = dataSellerResponseFromJson(jsonString);

import 'dart:convert';

DataSellerResponse dataSellerResponseFromJson(String str) => DataSellerResponse.fromJson(json.decode(str));

String dataSellerResponseToJson(DataSellerResponse data) => json.encode(data.toJson());

class DataSellerResponse {
    Data? data;
    bool? success;
    dynamic message;
    int? statusCode;
    dynamic errors;

    DataSellerResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory DataSellerResponse.fromJson(Map<String, dynamic> json) => DataSellerResponse(
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
    dynamic storeName;
    dynamic storeAddress;
    dynamic storeCity;
    dynamic whatsappNumber;
    dynamic storeMap;
    bool? liveStreamEnabled;
    bool? auctionEnabled;
    DateTime? joiningDate;
    String? status;
    bool? isVerifiedByAdmin;
    String? sellerType;
    String? userId;
    String? fullName;
    String? phone;
    bool? isActive;
    int? openAuctions;
    int? closedAuctions;
    int? activeLiveStreams;
    int? endedLiveStreams;
    int? productsCount;
    int? allAuctions;
    int? allLives;

    Data({
        this.storeName,
        this.storeAddress,
        this.storeCity,
        this.whatsappNumber,
        this.storeMap,
        this.liveStreamEnabled,
        this.auctionEnabled,
        this.joiningDate,
        this.status,
        this.isVerifiedByAdmin,
        this.sellerType,
        this.userId,
        this.fullName,
        this.phone,
        this.isActive,
        this.openAuctions,
        this.closedAuctions,
        this.activeLiveStreams,
        this.endedLiveStreams,
        this.productsCount,
        this.allAuctions,
        this.allLives,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeName: json["store_Name"],
        storeAddress: json["store_Address"],
        storeCity: json["store_City"],
        whatsappNumber: json["whatsapp_Number"],
        storeMap: json["store_Map"],
        liveStreamEnabled: json["liveStream_Enabled"],
        auctionEnabled: json["auction_Enabled"],
        joiningDate: json["joining_date"] == null ? null : DateTime.parse(json["joining_date"]),
        status: json["status"],
        isVerifiedByAdmin: json["is_Verified_By_Admin"],
        sellerType: json["sellerType"],
        userId: json["user_Id"],
        fullName: json["full_Name"],
        phone: json["phone"],
        isActive: json["isActive"],
        openAuctions: json["openAuctions"],
        closedAuctions: json["closedAuctions"],
        activeLiveStreams: json["activeLiveStreams"],
        endedLiveStreams: json["endedLiveStreams"],
        productsCount: json["products_Count"],
        allAuctions: json["allAuctions"],
        allLives: json["allLives"],
    );

    Map<String, dynamic> toJson() => {
        "store_Name": storeName,
        "store_Address": storeAddress,
        "store_City": storeCity,
        "whatsapp_Number": whatsappNumber,
        "store_Map": storeMap,
        "liveStream_Enabled": liveStreamEnabled,
        "auction_Enabled": auctionEnabled,
        "joining_date": joiningDate?.toIso8601String(),
        "status": status,
        "is_Verified_By_Admin": isVerifiedByAdmin,
        "sellerType": sellerType,
        "user_Id": userId,
        "full_Name": fullName,
        "phone": phone,
        "isActive": isActive,
        "openAuctions": openAuctions,
        "closedAuctions": closedAuctions,
        "activeLiveStreams": activeLiveStreams,
        "endedLiveStreams": endedLiveStreams,
        "products_Count": productsCount,
        "allAuctions": allAuctions,
        "allLives": allLives,
    };
}
