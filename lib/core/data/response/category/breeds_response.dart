// To parse this JSON data, do
//
//     final breedsResponse = breedsResponseFromJson(jsonString);

import 'dart:convert';

BreedsResponse breedsResponseFromJson(String str) => BreedsResponse.fromJson(json.decode(str));

String breedsResponseToJson(BreedsResponse data) => json.encode(data.toJson());

class BreedsResponse {
    Data? data;
    bool? success;
    dynamic message;
    int? statusCode;
    dynamic errors;

    BreedsResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory BreedsResponse.fromJson(Map<String, dynamic> json) => BreedsResponse(
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
    List<Breeds>? items;
    int? totalCount;
    int? pageNumber;
    int? pageSize;
    int? totalPages;

    Data({
        this.items,
        this.totalCount,
        this.pageNumber,
        this.pageSize,
        this.totalPages,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["items"] == null ? [] : List<Breeds>.from(json["items"]!.map((x) => Breeds.fromJson(x))),
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

class Breeds {
    int? id;
    String? breedName;
    int? productNumber;

    Breeds({
        this.id,
        this.breedName,
        this.productNumber,
    });

    factory Breeds.fromJson(Map<String, dynamic> json) => Breeds(
        id: json["id"],
        breedName: json["breed_Name"],
        productNumber: json["product_Number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "breed_Name": breedName,
        "product_Number": productNumber,
    };
}
