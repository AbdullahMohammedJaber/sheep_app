// To parse this JSON data, do
//
//     final detailsProductSellerResponse = detailsProductSellerResponseFromJson(jsonString);

import 'dart:convert';

DetailsProductSellerResponse detailsProductSellerResponseFromJson(String str) =>
    DetailsProductSellerResponse.fromJson(json.decode(str));

String detailsProductSellerResponseToJson(DetailsProductSellerResponse data) =>
    json.encode(data.toJson());

class DetailsProductSellerResponse {
  Data? data;
  bool? success;
  dynamic message;
  num? statusCode;
  dynamic errors;

  DetailsProductSellerResponse({
    this.data,
    this.success,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory DetailsProductSellerResponse.fromJson(Map<String, dynamic> json) =>
      DetailsProductSellerResponse(
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
  num? id;
  String? name;
  String? description;
  num? fixedPrice;
  num? sellerId;
  dynamic sellerName;
  num? categoryId;
  String? categoryName;
  num? wight;
  num? age;
  String? address;
  num? breedId;
  String? breedName;
  bool? isAuctioned;
  List<ImageProduct>? images;
  List<dynamic>? auctions;
  DateTime? createdAt;
  String? adsNumber;
  Data({
    this.id,
    this.name,
    this.description,
    this.fixedPrice,
    this.sellerId,
    this.sellerName,
    this.categoryId,
    this.categoryName,
    this.wight,
    this.age,
    this.address,
    this.breedId,
    this.breedName,
    this.isAuctioned,
    this.images,
    this.auctions,
    this.createdAt,
    this.adsNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    fixedPrice: json["fixed_Price"],
    sellerId: json["seller_Id"],
    sellerName: json["seller_Name"],
    categoryId: json["category_Id"],
    categoryName: json["category_Name"],
    wight: json["wight"],
    age: json["age"],
    address: json["address"],
    breedId: json["breed_Id"],
    breedName: json["breed_Name"],
    isAuctioned: json["is_Auctioned"],
    createdAt:
        json["created_At"] == null ? null : DateTime.parse(json["created_At"]),
    adsNumber: json["ads_Number"],
    images:
        json["images"] == null
            ? []
            : List<ImageProduct>.from(
              json["images"]!.map((x) => ImageProduct.fromJson(x)),
            ),
    auctions:
        json["auctions"] == null
            ? []
            : List<dynamic>.from(json["auctions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "fixed_Price": fixedPrice,
    "seller_Id": sellerId,
    "seller_Name": sellerName,
    "category_Id": categoryId,
    "category_Name": categoryName,
    "wight": wight,
    "age": age,
    "address": address,
    "breed_Id": breedId,
    "breed_Name": breedName,
    "is_Auctioned": isAuctioned,
    "created_At": createdAt?.toIso8601String(),
    "ads_Number": adsNumber,
    "images":
        images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
    "auctions":
        auctions == null ? [] : List<dynamic>.from(auctions!.map((x) => x)),
  };
}

class ImageProduct {
  num? id;
  String? imageName;
  bool? isPrimary;

  ImageProduct({this.id, this.imageName, this.isPrimary});

  factory ImageProduct.fromJson(Map<String, dynamic> json) => ImageProduct(
    id: json["id"],
    imageName: json["image_Name"],
    isPrimary: json["is_Primary"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image_Name": imageName,
    "is_Primary": isPrimary,
  };
}
