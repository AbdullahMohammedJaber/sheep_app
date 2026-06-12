// ignore_for_file: unused_field

import 'package:sheep/core/server/servise.dart';

class AppAssets {
  AppAssets._(); // Private constructor to prevent instantiation

  // Base Paths
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';

  // ================= Images =================
  // Add your image paths here:
  static const String logo = '$_imagesPath/logo.png';
  static const String test = '$_imagesPath/test.png';

  // ================= Icons =================
  // Add your icon paths here:
  static const String sheepIcon = '$_iconsPath/sheep.svg';
  static const String arrowLeft = '$_iconsPath/arrow-left.svg';
  static const String eye = '$_iconsPath/eye.svg';
  static const String google = '$_iconsPath/google.svg';
  static const String home = '$_iconsPath/home.svg';
  static const String auction = '$_iconsPath/auction.svg';
  static const String chat = '$_iconsPath/chat.svg';
  static const String search = '$_iconsPath/search.svg';
  static const String person = '$_iconsPath/person.svg';
  static const String searchNormal = '$_iconsPath/search-normal.svg';
  static const String filter = '$_iconsPath/filter.svg';
  static const String dropDown = '$_iconsPath/drop-down.svg';
  static const String location = '$_iconsPath/location.svg';
  static const String edit = '$_iconsPath/edit.svg';
  static const String lock = '$_iconsPath/lock.svg';
  static const String privacy = '$_iconsPath/privacy.svg';
  static const String aboutApp = '$_iconsPath/about_app.svg';
  static const String shareApp = '$_iconsPath/share_app.svg';
  static const String logout = '$_iconsPath/logout.svg';
  static const String delete = '$_iconsPath/delete.svg';
  static const String bell = '$_iconsPath/bell.svg';
  static const String go = '$_iconsPath/go.svg';
  static const String timer = '$_iconsPath/timer.svg';
  static const String product = '$_iconsPath/product.svg';
  static const String rate = '$_iconsPath/rate.svg';
  static const String share = '$_iconsPath/share.svg';
  static const String users = '$_iconsPath/users.svg';
  static const String car = '$_iconsPath/car.svg';
  static const String hashtag = '$_iconsPath/hashtag.svg';
  static const String userFollow = '$_iconsPath/user_follow.svg';
  static const String report = '$_iconsPath/report.svg';
  static const String phone = '$_iconsPath/phone.svg';
  static const String add = '$_iconsPath/add.svg';
  static const String live = '$_iconsPath/live.svg';
  static const String more = '$_iconsPath/more.svg';
  static const String store = '$_iconsPath/store.svg';

  static String parseImageUrl(String image) {
    return "${ApiService.url}/img/$image";
  }

  static String parseImageAuctionUrl(String image) {
    return "${ApiService.url}/auctionImg/$image";
  }

  static String parseImageStoreUrl(String image) {
    return "${ApiService.url}/storeImg/$image";
  }
}
