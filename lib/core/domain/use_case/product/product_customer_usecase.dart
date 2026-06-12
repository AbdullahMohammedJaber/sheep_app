 import 'package:sheep/core/data/response/product/product_customer_response.dart';
import 'package:sheep/core/domain/repo/product/product_customer_repo.dart';
import 'package:sheep/core/server/result.dart';

class ProductCustomerUsecase {
  ProductCustomerRepoImpl productCustomerRepoImpl;
  ProductCustomerUsecase(this.productCustomerRepoImpl);

  Future<ApiResult<ProductCustomerResponse>> callGetProducts({
    Map<String, dynamic>? query,
  }) async {
    return await productCustomerRepoImpl.getProducts(quary: query);
  }
}
