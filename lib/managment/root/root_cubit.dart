import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sheep/features/seller/profile/profile_screen.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/core/data/request/root/root_model.dart';
import 'package:sheep/features/conversation/conversation_screen.dart';
import 'package:sheep/features/customer/auction/all_auctions.dart';
import 'package:sheep/features/customer/home/home_screen.dart';
import 'package:sheep/features/customer/profile/profile_screen.dart';
import 'package:sheep/features/customer/search/search_screen.dart';
import 'package:sheep/features/seller/auction/manage_acution_screen.dart';
import 'package:sheep/features/seller/home/home_screen_seller.dart';
import 'package:sheep/features/seller/product/manage_product_screen.dart';

part 'root_state.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit() : super(RootState());

  List<Widget> screensCustomer = [
    HomeScreenCustomer(),
    AllAuctionsScreen(),
    ConversationScreen(),
    SearchScreenCustomer(),
    ProfilePage(),
  ];
  List<RootModel> iconsCustomer = [
    RootModel(id: 0, path: AppAssets.home, select: true),
    RootModel(id: 1, path: AppAssets.auction, select: false),
    RootModel(id: 2, path: AppAssets.chat, select: false),
    RootModel(id: 3, path: AppAssets.search, select: false),
    RootModel(id: 4, path: AppAssets.person, select: false),
  ];

  onClickBottomIcon(int id) {
    for (var element in iconsCustomer) {
      element.select = false;
    }
    for (var element in iconsCustomer) {
      if (element.id == id) {
        element.select = true;
      }
    }
    emit(state.copyWith(currenPage: id));
  }

  List<Widget> screensSeller = [
    HomeScreenSeller(),
    ManageProductScreen(),
    ManageAcutionScreen(),
    ConversationScreen(),
    ProdileSellerScreen(),
  ];
  List<RootModel> iconsSeller = [
    RootModel(id: 0, path: AppAssets.home, select: true),
    RootModel(id: 1, path: AppAssets.product, select: false),

    RootModel(id: 2, path: AppAssets.auction, select: false),
    RootModel(id: 3, path: AppAssets.chat, select: false),
    RootModel(id: 4, path: AppAssets.person, select: false),
  ];
  onClickBottomIconSeller(int id) {
    for (var element in iconsSeller) {
      element.select = false;
    }
    for (var element in iconsSeller) {
      if (element.id == id) {
        element.select = true;
      }
    }
    emit(state.copyWith(currenPage: id));
  }
}
