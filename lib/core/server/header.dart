import 'package:sheep/managment/auth/helper.dart';

class ApiHeaders {
  static Map<String, String> get headers => {
    'Accept': 'application/json',
    'Accept-Language': 'ar',
    'lang': 'ar',
    'Authorization': 'Bearer ${HelperAuth().getUser()?.data?.accessToken??""}',
    // 'fcmToken': getFcmToken() ?? '123',
    // 'device_token': getFcmToken() ?? '123',
    'Content-Type': 'application/json',
    // 'API-KEY': '123456',
    // 'x-shop-id': getMyShopsDetails().id.toString(),
  };
}
