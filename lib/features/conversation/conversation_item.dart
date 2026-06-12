import 'package:flutter/material.dart';
import 'package:sheep/core/data/response/chat/conversation_response.dart';

import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/conversation/chat_screen.dart';
import 'package:sheep/main.dart';
import 'package:shimmer/shimmer.dart';

class ConversationItem extends StatelessWidget {
  final ConversationItemResponse conversationItemResponse;
  const ConversationItem({super.key, required this.conversationItemResponse});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (conversationItemResponse.id == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ChatScreen(
                  entryType: ChatEntryType.fromConversationList,
                  conversationId: conversationItemResponse.id!,
                  sellerName:
                      (conversationItemResponse.name ?? 'اسم المستخدم')
                          .toString(),
                ),
          ),
        );
      },
      child: Container(
        height: hi * 0.09,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AppAssets.test),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: wi * 0.02),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: conversationItemResponse.name ?? "اسم المستخدم",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  SizedBox(height: hi * 0.01),
                  CustomText(
                    text: conversationItemResponse.lastMessage ?? "",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff7A7A7A),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error,
                    ),
                    child: Center(
                      child: CustomText(
                        text: "${conversationItemResponse.un_Read_Messages ?? 0}",
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: hi * 0.01),
                  CustomText(
                    text: ChatDateFormatter.format(
                      conversationItemResponse.lastMessageDate!,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff7A7A7A),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatDateFormatter {
  static String format(DateTime? date) {
    if (date == null) return "";

    final now = DateTime.now();
    final localDate = date;

    final diff = now.difference(localDate);

    final today = DateTime(now.year, now.month, now.day);
    final messageDay =
        DateTime(localDate.year, localDate.month, localDate.day);

    final dayDiff = today.difference(messageDay).inDays;

    /// 🔥 الآن (أقل من دقيقة)
    if (diff.inMinutes < 1) {
      return "الآن";
    }

    /// 🔥 منذ دقائق
    if (diff.inMinutes < 60) {
      return "منذ ${diff.inMinutes} دقيقة";
    }

    /// 🔥 اليوم (يعرض الوقت)
    if (dayDiff == 0) {
      return _formatTime(localDate);
    }

    /// 🔥 أمس
    if (dayDiff == 1) {
      return "أمس";
    }

    /// 🔥 خلال الأسبوع
    if (dayDiff < 7) {
      return _weekdayName(localDate.weekday);
    }

    /// 🔥 تاريخ كامل
    return "${localDate.day}/${localDate.month}/${localDate.year}";
  }

  static String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? "م" : "ص";

    return "$hour:$minute $period";
  }

  static String _weekdayName(int day) {
    switch (day) {
      case DateTime.saturday:
        return "السبت";
      case DateTime.sunday:
        return "الأحد";
      case DateTime.monday:
        return "الاثنين";
      case DateTime.tuesday:
        return "الثلاثاء";
      case DateTime.wednesday:
        return "الأربعاء";
      case DateTime.thursday:
        return "الخميس";
      case DateTime.friday:
        return "الجمعة";
      default:
        return "";
    }
  }
}

class ConversationItemShimmer extends StatelessWidget {
  const ConversationItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: hi * 0.09,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            /// avatar
            Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),

            SizedBox(width: wi * 0.02),

            /// text area
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 120, color: Colors.white),
                  SizedBox(height: hi * 0.01),
                  Container(height: 10, width: 180, color: Colors.white),
                ],
              ),
            ),

            /// right side
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 22,
                  width: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: hi * 0.01),
                Container(height: 10, width: 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
