import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/widgets/custom_text.dart';

Widget dataStore({
  required String phone,
  required String name,
  required String location,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "معلومات المتجر",
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xff223B50),
        ),

        const SizedBox(height: 12),

        _infoRow(AppAssets.phone, "رقم الجوال : ", phone),
        _infoRow(AppAssets.store, "اسم المتجر : ", name),
        _infoRow(
          AppAssets.location,
          "الموقع : ",
          location,
        ),
      ],
    ),
  );
}

Widget _infoRow(String icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(icon),
        const SizedBox(width: 6),
        Text(title),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
