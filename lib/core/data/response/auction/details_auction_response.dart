// To parse this JSON data, do
//
//     final detailsAuctionsResponse = detailsAuctionsResponseFromJson(jsonString);

import 'dart:convert';

DetailsAuctionsResponse detailsAuctionsResponseFromJson(String str) =>
    DetailsAuctionsResponse.fromJson(json.decode(str));

String detailsAuctionsResponseToJson(DetailsAuctionsResponse data) =>
    json.encode(data.toJson());

class DetailsAuctionsResponse {
  AuctionDetails? data;
  bool? success;
  dynamic message;
  num? statusCode;
  dynamic errors;

  DetailsAuctionsResponse({
    this.data,
    this.success,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory DetailsAuctionsResponse.fromJson(Map<String, dynamic> json) =>
      DetailsAuctionsResponse(
        data:
            json["data"] == null ? null : AuctionDetails.fromJson(json["data"]),
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

class AuctionDetails {
  num? id;
  String? title;
  String? description;
  dynamic address;
  num? currentPrice;
  num? startPrice;
  DateTime? startTime;
  DateTime? endTime;
  num? status;
  List<AuctionBid>? bids;
  List<ImageAuction>? images;
  num? sellerId;
  String? sellerName;
  String? userName;
  AuctionDetails({
    this.id,
    this.title,
    this.userName,
    this.description,
    this.address,
    this.currentPrice,
    this.startPrice,
    this.startTime,
    this.endTime,
    this.status,
    this.bids,
    this.images,
    this.sellerId,
    this.sellerName,
  });

  factory AuctionDetails.fromJson(Map<String, dynamic> json) => AuctionDetails(
    id: json["id"],
    sellerId: json["seller_Id"],
    sellerName: json["seller_Name"],
    userName: json["user_Name"],
    startPrice: json["start_Price"],
    title: json["title"],
    description: json["description"],
    address: json["address"],
    currentPrice: json["current_Price"],
    startTime:
        json["start_Time"] == null ? null : DateTime.parse(json["start_Time"]),
    endTime: json["end_Time"] == null ? null : DateTime.parse(json["end_Time"]),
    status: json["status"],
    bids:
        json["bids"] == null
            ? []
            : List<AuctionBid>.from(
              json["bids"]!.map((x) => AuctionBid.fromJson(x)),
            ),
    images:
        json["images"] == null
            ? []
            : List<ImageAuction>.from(
              json["images"]!.map((x) => ImageAuction.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_Price": startPrice,
    "title": title,
    "user_Name": userName,
    "description": description,
    "address": address,
    "current_Price": currentPrice,
    "start_Time": startTime?.toIso8601String(),
    "end_Time": endTime?.toIso8601String(),
    "status": status,
    "seller_Id": sellerId,
    "seller_Name": sellerName,
  
    "bids":
        bids == null ? [] : List<dynamic>.from(bids!.map((x) => x.toJson())),
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}

class AuctionBid {
  num? amount;
  DateTime? createdAt;
  String? customerId;
  String? customerName;

  AuctionBid({
    this.amount,
    this.createdAt,
    this.customerId,
    this.customerName,
  });

  factory AuctionBid.fromJson(Map<String, dynamic> json) {
    final rawDate = json["created_At"];

    DateTime? parsedDate;

    if (rawDate != null) {
      final normalized =
          rawDate.toString().endsWith('Z') ? rawDate : '${rawDate}Z';

      parsedDate = DateTime.parse(normalized).toLocal();
    }

    return AuctionBid(
      amount: json["amount"],
      createdAt: parsedDate,
      customerId: json["customer_Id"]?.toString(),
      customerName: json["customer_Name"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "created_At": createdAt?.toUtc().toIso8601String(),
        "customer_Id": customerId,
        "customer_Name": customerName,
      };
}
DateTime? parseServerDate(dynamic rawDate) {
  if (rawDate == null) return null;

  final value = rawDate.toString();

  final normalized = value.endsWith('Z') ? value : '${value}Z';

  return DateTime.parse(normalized).toLocal();
}
class ImageAuction {
  num? id;
  String? imageName;

  ImageAuction({this.id, this.imageName});

  factory ImageAuction.fromJson(Map<String, dynamic> json) =>
      ImageAuction(id: json["id"], imageName: json["image_Name"]);

  Map<String, dynamic> toJson() => {"id": id, "image_Name": imageName};
}
