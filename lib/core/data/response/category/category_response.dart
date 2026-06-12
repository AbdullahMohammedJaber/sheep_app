// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);

import 'dart:convert';

CategoryResponse categoryResponseFromJson(String str) => CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) => json.encode(data.toJson());

class CategoryResponse {
    Data? data;
    bool? success;
    dynamic message;
    int? statusCode;
    dynamic errors;

    CategoryResponse({
        this.data,
        this.success,
        this.message,
        this.statusCode,
        this.errors,
    });

    factory CategoryResponse.fromJson(Map<String, dynamic> json) => CategoryResponse(
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
    List<Category>? items;
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
        items: json["items"] == null ? [] : List<Category>.from(json["items"]!.map((x) => Category.fromJson(x))),
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

class Category {
    int? id;
    String? categoryName;
    int? categoryType;
    String? description;
    int? productNumber;

    Category({
        this.id,
        this.categoryName,
        this.categoryType,
        this.description,
        this.productNumber,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_Name"],
        categoryType: json["category_Type"],
        description: json["description"],
        productNumber: json["product_Number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_Name": categoryName,
        "category_Type": categoryType,
        "description": description,
        "product_Number": productNumber,
    };
}
