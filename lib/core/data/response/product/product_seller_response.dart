// To parse this JSON data, do
//
//     final productSellerResponse = productSellerResponseFromJson(jsonString);

import 'dart:convert';

ProductSellerResponse productSellerResponseFromJson(String str) => ProductSellerResponse.fromJson(json.decode(str));

String productSellerResponseToJson(ProductSellerResponse data) => json.encode(data.toJson());

class ProductSellerResponse {
    Data? data;
    bool? success;
    dynamic message;
    num? statusCode;
    dynamic errors;

    ProductSellerResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory ProductSellerResponse.fromJson(Map<String, dynamic> json) => ProductSellerResponse(
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
    List<ProductSeller>? items;
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
        items: json["items"] == null ? [] : List<ProductSeller>.from(json["items"]!.map((x) => ProductSeller.fromJson(x))),
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

class ProductSeller {
    num? id;
    String? name;
    String? description;
    num? fixedPrice;
    num? sellerId;
    dynamic sellerName;
    num? categoryId;
    String? categoryName;
    bool? isAuctioned;
    String? imageName;
    num? wight;
    num? age;
    String? address;
    num? breedId;
    String? breedName;

    ProductSeller({
        this.id,
        this.name,
        this.description,
        this.fixedPrice,
        this.sellerId,
        this.sellerName,
        this.categoryId,
        this.categoryName,
        this.isAuctioned,
        this.imageName,
        this.wight,
        this.age,
        this.address,
        this.breedId,
        this.breedName,
    });

    factory ProductSeller.fromJson(Map<String, dynamic> json) => ProductSeller(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        fixedPrice: json["fixed_Price"],
        sellerId: json["seller_Id"],
        sellerName: json["seller_Name"],
        categoryId: json["category_Id"],
        categoryName: json["category_Name"],
        isAuctioned: json["is_Auctioned"],
        imageName: json["image_Name"],
        wight: json["wight"],
        age: json["age"],
        address: json["address"],
        breedId: json["breed_Id"],
        breedName: json["breed_Name"],
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
        "is_Auctioned": isAuctioned,
        "image_Name": imageName,
        "wight": wight,
        "age": age,
        "address": address,
        "breed_Id": breedId,
        "breed_Name": breedName,
    };
}
