 
import 'package:bot_toast/bot_toast.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
 import 'package:sheep/util/NavigatorObserver/Navigator_observe.dart';
import 'package:sheep/util/constants/app_colors.dart';

showMessage(String message, {required bool value}) {
  if (value) {
    CherryToast.success(
      title: Text(message, style: TextStyle(color: AppColors.black)),
    ).show(NavigationService.navigatorKey.currentContext!);
  } else {
    CherryToast.error(
      title: Text(message, style: TextStyle(color: AppColors.black)),
    ).show(NavigationService.navigatorKey.currentContext!);
  }
}

showBoatToast() {
  BotToast.showCustomLoading(
    toastBuilder: (wid) {
      return  Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

closeAllLoading() {
  BotToast.closeAllLoading();
}

