import 'dart:convert';

ShopDetailsResponse shopDetailsResponseFromJson(String str) =>
    ShopDetailsResponse.fromJson(json.decode(str));

String shopDetailsResponseToJson(ShopDetailsResponse data) =>
    json.encode(data.toJson());

class ShopDetailsResponse {
  ShopDetailsData? data;
  bool? success;
  dynamic message;
  int? statusCode;
  dynamic errors;

  ShopDetailsResponse({
    this.data,
    this.success,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ShopDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ShopDetailsResponse(
      data: json["data"] == null
          ? null
          : ShopDetailsData.fromJson(json["data"]),
      success: json["success"],
      message: json["message"],
      statusCode: json["statusCode"],
      errors: json["errors"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "errors": errors,
      };
}

class ShopDetailsData {
  String? storeName;
  String? storeAddress;
  String? storeCity;
  String? whatsappNumber;
  String? storeMap;

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
  String? image;

  int? openAuctions;
  int? closedAuctions;
  int? activeLiveStreams;
  int? endedLiveStreams;
  int? productsCount;
  int? allAuctions;
  int? allLives;
  int? seller_Id;
  ShopDetailsData({
    this.storeName,
    this.seller_Id,
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
    this.image,
    this.openAuctions,
    this.closedAuctions,
    this.activeLiveStreams,
    this.endedLiveStreams,
    this.productsCount,
    this.allAuctions,
    this.allLives,
  });

  factory ShopDetailsData.fromJson(Map<String, dynamic> json) {
    return ShopDetailsData(
      seller_Id: _toInt(json["seller_Id"]),
      storeName: json["store_Name"]?.toString(),
      storeAddress: json["store_Address"]?.toString(),
      storeCity: json["store_City"]?.toString(),
      whatsappNumber: json["whatsapp_Number"]?.toString(),
      storeMap: json["store_Map"]?.toString(),
      liveStreamEnabled: json["liveStream_Enabled"],
      auctionEnabled: json["auction_Enabled"],
      joiningDate: _parseServerDate(json["joining_date"]),
      status: json["status"]?.toString(),
      isVerifiedByAdmin: json["is_Verified_By_Admin"],
      sellerType: json["sellerType"]?.toString(),
      userId: json["user_Id"]?.toString(),
      fullName: json["full_Name"]?.toString(),
      phone: json["phone"]?.toString(),
      isActive: json["isActive"],
      image: json["image"]?.toString(),
      openAuctions: _toInt(json["openAuctions"]),
      closedAuctions: _toInt(json["closedAuctions"]),
      activeLiveStreams: _toInt(json["activeLiveStreams"]),
      endedLiveStreams: _toInt(json["endedLiveStreams"]),
      productsCount: _toInt(json["products_Count"]),
      allAuctions: _toInt(json["allAuctions"]),
      allLives: _toInt(json["allLives"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "store_Name": storeName,
        "seller_Id": seller_Id,
        "store_Address": storeAddress,
        "store_City": storeCity,
        "whatsapp_Number": whatsappNumber,
        "store_Map": storeMap,
        "liveStream_Enabled": liveStreamEnabled,
        "auction_Enabled": auctionEnabled,
        "joining_date": joiningDate?.toUtc().toIso8601String(),
        "status": status,
        "is_Verified_By_Admin": isVerifiedByAdmin,
        "sellerType": sellerType,
        "user_Id": userId,
        "full_Name": fullName,
        "phone": phone,
        "isActive": isActive,
        "image": image,
        "openAuctions": openAuctions,
        "closedAuctions": closedAuctions,
        "activeLiveStreams": activeLiveStreams,
        "endedLiveStreams": endedLiveStreams,
        "products_Count": productsCount,
        "allAuctions": allAuctions,
        "allLives": allLives,
      };

  static DateTime? _parseServerDate(dynamic rawDate) {
    if (rawDate == null) return null;

    final value = rawDate.toString();
    final normalized = value.endsWith('Z') ? value : '${value}Z';

    return DateTime.parse(normalized).toLocal();
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}