// To parse this JSON data, do
//
//     final auctionCustomerResponse = auctionCustomerResponseFromJson(jsonString);

import 'dart:convert';

AuctionCustomerResponse auctionCustomerResponseFromJson(String str) => AuctionCustomerResponse.fromJson(json.decode(str));

String auctionCustomerResponseToJson(AuctionCustomerResponse data) => json.encode(data.toJson());

class AuctionCustomerResponse {
    Data? data;
    bool? success;
    dynamic message;
    num? statusCode;
    dynamic errors;

    AuctionCustomerResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory AuctionCustomerResponse.fromJson(Map<String, dynamic> json) => AuctionCustomerResponse(
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
    List<AuctionCustomer>? items;
    num? totalCount;
    num? pageNumber;
    num? pageSize;
    num? totalPages;

    Data({
        this.items,
        this.totalCount,
        this.pageNumber,
        this.pageSize,
        this.totalPages,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["items"] == null ? [] : List<AuctionCustomer>.from(json["items"]!.map((x) => AuctionCustomer.fromJson(x))),
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

class AuctionCustomer {
    num? id;
    String? title;
    num? status;
    String? description;
    dynamic address;
    num? startPrice;
    num? currentPrice;
    DateTime? startTime;
    DateTime? endTime;
    num? bidsCount;
    String? imageName;

    AuctionCustomer({
        this.id,
        this.title,
        this.status,
        this.description,
        this.address,
        this.startPrice,
        this.currentPrice,
        this.startTime,
        this.endTime,
        this.bidsCount,
        this.imageName,
    });

    factory AuctionCustomer.fromJson(Map<String, dynamic> json) => AuctionCustomer(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        description: json["description"],
        address: json["address"],
        startPrice: json["start_Price"],
        currentPrice: json["current_Price"],
        startTime: json["start_Time"] == null ? null : DateTime.parse(json["start_Time"]),
        endTime: json["end_Time"] == null ? null : DateTime.parse(json["end_Time"]),
        bidsCount: json["bids_Count"],
        imageName: json["image_Name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "description": description,
        "address": address,
        "start_Price": startPrice,
        "current_Price": currentPrice,
        "start_Time": startTime?.toIso8601String(),
        "end_Time": endTime?.toIso8601String(),
        "bids_Count": bidsCount,
        "image_Name": imageName,
    };
}
