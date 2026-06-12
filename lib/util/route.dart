// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sheep/util/NavigatorObserver/Navigator_observe.dart';

Future To(BuildContext context, Widget widget) async {
  return await Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute(builder: (BuildContext context) => widget));
}

Future ToWithFade(BuildContext context, Widget widget) async {
  return await Navigator.of(
    NavigationService.navigatorKey.currentContext!,
  ).push(
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => widget,
      transitionsBuilder: (c, anim, a2, child) {
        return FadeTransition(opacity: anim, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    ),
  );
}

Future ToRemove(BuildContext context, Widget widget) async {
  return await Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => widget,
      transitionsBuilder: (c, anim, a2, child) {
        return FadeTransition(opacity: anim, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    ),
  );
}

Future toRemoveAll(Widget widget) async {
  Navigator.pushAndRemoveUntil(
    NavigationService.navigatorKey.currentContext!,
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => widget,
      transitionsBuilder: (c, anim, a2, child) {
        return FadeTransition(opacity: anim, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    ),
    (_) => false,
  );
}

Future ToRemoveExcept(BuildContext context, Widget widget) async {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (BuildContext context) => widget),
    (Route<dynamic> route) {
      return route.isFirst;
    },
  );
}
