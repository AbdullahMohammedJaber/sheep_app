import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sheep/firebase_options.dart';
import 'package:sheep/managment/auction/auction_hub_service.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auction/seller/filter_seller_auction_cubit.dart';
import 'package:sheep/managment/auth/auth_cubit.dart';
import 'package:sheep/managment/category/category_cubit.dart';
import 'package:sheep/managment/chat/chat_cubit.dart';
import 'package:sheep/managment/chat/chat_hub_service.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/managment/notification/notification_cubit.dart';
import 'package:sheep/managment/product/customer/filter_customer_product_cubit.dart';
import 'package:sheep/managment/product/customer/product_customer_cubit.dart';
import 'package:sheep/managment/product/seller/filter_seller_product_cubit.dart';
import 'package:sheep/managment/shop/customer/shop_customer_cubit.dart';
import 'package:sheep/util/NavigatorObserver/Navigator_observe.dart';
import 'package:sheep/managment/root/root_cubit.dart';
import 'package:sheep/util/fcm/fcm.dart';
import 'util/constants/app_strings.dart';
import 'util/theme/app_theme.dart';
import 'features/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService().init();

  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await GetStorage.init();

  runApp(DevicePreview(
    builder: (context) {
      return MyApp();
    },
    enabled: true,));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var botToastBuilder = BotToastInit();
  @override
  void initState() {
    super.initState();

    botToastBuilder = BotToastInit();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RootCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => AuctionCustomerCubit(AuctionHubService())),
        BlocProvider(create: (_) => ProductCustomerCubit()),
        BlocProvider(create: (_) => ShopCustomerCubit()),
        BlocProvider(create: (_) => NotificationsCubit()),
        BlocProvider(create: (_) => CategoryCubit()),
        BlocProvider(create: (_) => HomeSellerCubit()),
        BlocProvider(create: (_) => ProductFilterSellerCubit()),
        BlocProvider(create: (_) => ProductFilterCustomerCubit()),
        BlocProvider<ChatCubit>(create: (_) => ChatCubit(ChatHubService())),
        BlocProvider(create: (_) => AuctionFilterSellerCubit()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        theme: AppTheme.lightTheme,
        navigatorObservers: [BotToastNavigatorObserver()],
        home: const SplashPage(),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          child = botToastBuilder(context, child);
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: Scaffold(body: Stack(children: [child])),
          );
        },
      ),
    );
  }
}

double hi = 0.0;
double wi = 0.0;
