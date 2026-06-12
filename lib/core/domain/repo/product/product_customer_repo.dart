 import 'package:sheep/core/data/response/product/product_customer_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

import '../../../data/data_source/product/product_customer_data_source.dart';

abstract class ProductCustomerRepo {
  Future<ApiResult<ProductCustomerResponse>> getProducts({Map<String, dynamic>? quary});
}

class ProductCustomerRepoImpl extends ProductCustomerRepo {
  ProductCustomerDataSourceImpl productCustomerDataSourceImpl;
  ProductCustomerRepoImpl(this.productCustomerDataSourceImpl);
  @override
  Future<ApiResult<ProductCustomerResponse>> getProducts({
    Map<String, dynamic>? quary,
  }) async {
    final result = await productCustomerDataSourceImpl.getProducts(
      quary: quary,
    );

    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(ProductCustomerResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }
}
