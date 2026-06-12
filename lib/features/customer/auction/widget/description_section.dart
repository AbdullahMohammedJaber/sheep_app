  import 'package:flutter/material.dart';
import 'package:sheep/util/widgets/custom_text.dart';

Widget  buildDescription({String ?des}) {
    return CustomText(
      text: des??"",
      overflow: TextOverflow.visible,
      
    );
  }
