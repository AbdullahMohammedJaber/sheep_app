import 'package:sheep/core/data/data_source/auction/auction_customer_data_source.dart';
import 'package:sheep/core/data/data_source/auction/auction_seller_data_source.dart';
import 'package:sheep/core/data/data_source/auth/auth_data_source.dart';
import 'package:sheep/core/data/data_source/category/category_data_source.dart';
import 'package:sheep/core/data/data_source/chat/chat_data_source.dart';
import 'package:sheep/core/data/data_source/home/seller/home_seller_data_source.dart';
import 'package:sheep/core/data/data_source/live/live_customer_data_source.dart';
import 'package:sheep/core/data/data_source/live/live_seller_data_source.dart';
import 'package:sheep/core/data/data_source/product/product_customer_data_source.dart';
import 'package:sheep/core/data/data_source/product/product_seller_data_source.dart';
import 'package:sheep/core/data/data_source/shop/shop_data_source.dart';
import 'package:sheep/core/domain/repo/auction/auction_customer_repo.dart';
import 'package:sheep/core/domain/repo/auction/auction_seller_repo.dart';
import 'package:sheep/core/domain/repo/auth/auth_repo.dart';
import 'package:sheep/core/domain/repo/category/category_repo.dart';
import 'package:sheep/core/domain/repo/chat/chat_repo.dart';
import 'package:sheep/core/domain/repo/home/seller/home_seller_repo.dart';
import 'package:sheep/core/domain/repo/live/live_customer_repo.dart';
import 'package:sheep/core/domain/repo/live/live_seller_repo.dart';
import 'package:sheep/core/domain/repo/product/product_customer_repo.dart';
import 'package:sheep/core/domain/repo/product/product_seller_repo.dart';
import 'package:sheep/core/domain/repo/shop/shop_repo.dart';
import 'package:sheep/core/domain/use_case/auction/auction_customer_usecase.dart';
import 'package:sheep/core/domain/use_case/auction/auction_seller_usecase.dart';
import 'package:sheep/core/domain/use_case/auth/auth_use_case.dart';
import 'package:sheep/core/domain/use_case/category/category_usecase.dart';
import 'package:sheep/core/domain/use_case/chat/chat_usecase.dart';
import 'package:sheep/core/domain/use_case/home/seller/home_seller_usecase.dart';
import 'package:sheep/core/domain/use_case/live/live_customer_usecase.dart';
import 'package:sheep/core/domain/use_case/live/live_seller_usecase.dart';
import 'package:sheep/core/domain/use_case/product/product_customer_usecase.dart';
import 'package:sheep/core/domain/use_case/product/product_seller_usecase.dart';
import 'package:sheep/core/domain/use_case/shop/shop_usecase.dart';
import 'package:sheep/core/server/dio_helper.dart';

class UserCaseState {
  final authUserCase = AuthUseCase(
    AuthRepoImpl(AuthDataSourceImpl(DioClient())),
  );

  final auctionCustomerUserCase = AuctionCustomerUsecase(
    AuctionCustomerRepoImpl(AuctionCustomerDataSourceImpl(DioClient())),
  );
  final shopUseCase = ShopUsecase(
    ShopRepoImpl(ShopDataSourceImpl(DioClient())),
  );
  final productCustomerUsercase = ProductCustomerUsecase(
    ProductCustomerRepoImpl(ProductCustomerDataSourceImpl(DioClient())),
  );

  final categoryUserCase = CategoryUsecase(
    CategoryRepoImpl(CategoryDataSourceImpl(DioClient())),
  );
  final productSellerUserCase = ProductSellerUsecase(
    ProductSellerRepoImpl(ProductSellerDataSourceImpl(DioClient())),
  );
  final homeSellerUserCase = HomeSellerUsecase(
    HomeSellerRepoImpl(HomeSellerDataSourceImpl(DioClient())),
  );
  final auctionSellerUserCase = AuctionSellerUsecase(
    AuctionSellerRepoImpl(AuctionSellerDataSourceImpl(DioClient())),
  );
  final chatUserCase = ChatUsecase(
    ChatRepoImpl(ChatDataSourceImpl(DioClient())),
  );
  final liveSellerUserCase = LiveSellerUsecase(
    LiveSellerRepoImpl(LiveSellerDataSourceImpl(DioClient())),
  );

  final liveCustomerUserCase = LiveCustomerUsecase(LiveCustomerRepoImpl(LiveCustomerDataSourceImpl(DioClient())));
}
