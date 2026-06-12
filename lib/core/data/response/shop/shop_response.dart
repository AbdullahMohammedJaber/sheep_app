// To parse this JSON data, do
//
//     final shopsResponse = shopsResponseFromJson(jsonString);

import 'dart:convert';

ShopsResponse shopsResponseFromJson(String str) => ShopsResponse.fromJson(json.decode(str));

String shopsResponseToJson(ShopsResponse data) => json.encode(data.toJson());

class ShopsResponse {
    List<ShopItemRes>? items;
    int? totalCount;
    int? pageNumber;
    int? pageSize;
    int? totalPages;

    ShopsResponse({
        this.items,
        this.totalCount,
        this.pageNumber,
        this.pageSize,
        this.totalPages,
    });

    factory ShopsResponse.fromJson(Map<String, dynamic> json) => ShopsResponse(
        items: json["items"] == null ? [] : List<ShopItemRes>.from(json["items"]!.map((x) => ShopItemRes.fromJson(x))),
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

class ShopItemRes {
    dynamic userId;
    String? fullName;
    String? phone;
    dynamic itemStoreName;
    dynamic storeAddress;
    dynamic storeCity;
    dynamic whatsappNumber;
    DateTime? joinedAt;
    String? sellerType;
    String? status;
    dynamic image;
    bool? isActive;
    bool? liveStreamEnabled;
    bool? auctionEnabled;
    dynamic storeName;
    dynamic city;

    ShopItemRes({
        this.userId,
        this.fullName,
        this.phone,
        this.itemStoreName,
        this.storeAddress,
        this.storeCity,
        this.whatsappNumber,
        this.joinedAt,
        this.sellerType,
        this.status,
        this.image,
        this.isActive,
        this.liveStreamEnabled,
        this.auctionEnabled,
        this.storeName,
        this.city,
    });

    factory ShopItemRes.fromJson(Map<String, dynamic> json) => ShopItemRes(
        userId: json["userId"],
        fullName: json["fullName"],
        phone: json["phone"],
        itemStoreName: json["store_Name"],
        storeAddress: json["store_Address"],
        storeCity: json["store_City"],
        whatsappNumber: json["whatsapp_Number"],
        joinedAt: json["joined_At"] == null ? null : DateTime.parse(json["joined_At"]),
        sellerType: json["sellerType"],
        status: json["status"],
        image: json["image"],
        isActive: json["isActive"],
        liveStreamEnabled: json["liveStreamEnabled"],
        auctionEnabled: json["auctionEnabled"],
        storeName: json["storeName"],
        city: json["city"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "fullName": fullName,
        "phone": phone,
        "store_Name": itemStoreName,
        "store_Address": storeAddress,
        "store_City": storeCity,
        "whatsapp_Number": whatsappNumber,
        "joined_At": joinedAt?.toIso8601String(),
        "sellerType": sellerType,
        "status": status,
        "image": image,
        "isActive": isActive,
        "liveStreamEnabled": liveStreamEnabled,
        "auctionEnabled": auctionEnabled,
        "storeName": storeName,
        "city": city,
    };
}
