// ignore_for_file: deprecated_member_use

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/features/auth/widget/widget_auth.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/live/live_seller_cubit.dart';
import 'package:sheep/managment/live/live_seller_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/message_flash.dart';
 import 'package:sheep/util/widgets/custom_text.dart';

class LiveCreatePage extends StatelessWidget {
  const LiveCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LiveCreateView();
  }
}

class _LiveCreateView extends StatefulWidget {
  const _LiveCreateView();

  @override
  State<_LiveCreateView> createState() => _LiveCreateViewState();
}

class _LiveCreateViewState extends State<_LiveCreateView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SellerLiveCubit>();

    return BlocListener<SellerLiveCubit, SellerLiveState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage ||
            previous.successMessage != current.successMessage;
      },
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          showMessage(state.errorMessage!, value: false);
          cubit.clearMessages();
          return;
        }

        if (state.successMessage != null && state.successMessage!.isNotEmpty) {
          showMessage(state.successMessage!, value: true);

          cubit.clearMessages();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        body: SafeArea(
          child: BlocBuilder<SellerLiveCubit, SellerLiveState>(
            builder: (context, state) {
              final isInitializing = state.status == SellerLiveStatus.preparing;
              final isStarting = state.status == SellerLiveStatus.starting;

              return Column(
                children: [
                  arrowLift(context, "استعداد للبث المباشر"),
                  SizedBox(height: hi * 0.01),
                  const Divider(color: AppColors.border, thickness: 1),
                  SizedBox(height: hi * 0.02),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const _SectionTitle(title: 'معاينة الكاميرا'),
                          const SizedBox(height: 14),
                          _CameraPreviewCard(
                            engine: cubit.engine,
                            isCameraOn: state.isCameraOn,
                            isMicOn: state.isMicOn,
                            isPreviewReady: state.isPreviewReady,
                            isInitializing: isInitializing,
                            onCameraTap: cubit.toggleCamera,
                            onMicTap: cubit.toggleMic,
                          ),
                          SizedBox(height: hi * 0.04),
                          const _SectionTitle(title: 'عنوان البث'),
                          SizedBox(height: hi * 0.01),
                          _CustomTextField(
                            controller: _titleController,
                            hintText: 'ادخل عنوان البث',
                            onChanged: cubit.onTitleChanged,
                          ),
                          SizedBox(height: hi * 0.01),
                          const _SectionTitle(title: 'الوصف'),
                          SizedBox(height: hi * 0.01),
                          _CustomTextField(
                            controller: _descriptionController,
                            hintText: 'اكتب وصف للبث',
                            maxLines: 5,
                            onChanged: cubit.onDescriptionChanged,
                          ),
                          const SizedBox(height: 26),
                          const _TipsCard(),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    color: const Color(0xFFF8F8F8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 108,
                          height: 56,
                          child: OutlinedButton(
                            onPressed:
                                isStarting
                                    ? null
                                    : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFD9D9D9)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child:  CustomText(
                             text:  'إلغاء',
                              color: AppColors.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isStarting ? null : cubit.startLive,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFFD4AF37),
                                disabledBackgroundColor: const Color(
                                  0xFFD4AF37,
                                ).withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child:
                                  isStarting
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      :  CustomText(
                                       text:  'ابدأ البث المباشر',
                                         color: Colors.white,
                                          fontSize: 18,
                                        
                                          fontWeight: FontWeight.w800,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomText(
        text: title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _CameraPreviewCard extends StatelessWidget {
  final RtcEngine? engine;
  final bool isCameraOn;
  final bool isMicOn;
  final bool isPreviewReady;
  final bool isInitializing;
  final Future<void> Function() onCameraTap;
  final Future<void> Function() onMicTap;

  const _CameraPreviewCard({
    required this.engine,
    required this.isCameraOn,
    required this.isMicOn,
    required this.isPreviewReady,
    required this.isInitializing,
    required this.onCameraTap,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SizedBox.expand(child: _buildPreviewContent()),
          ),
          Positioned(
            bottom: 26,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleControlButton(
                  icon:
                      isCameraOn
                          ? Icons.videocam_outlined
                          : Icons.videocam_off_outlined,
                  backgroundColor: Colors.white.withOpacity(0.92),
                  iconColor: const Color(0xFF24415C),
                  onTap: onCameraTap,
                ),
                const SizedBox(width: 22),
                _CircleControlButton(
                  icon:
                      isMicOn ? Icons.mic_none_rounded : Icons.mic_off_rounded,
                  backgroundColor: const Color(0xFFF7F3E7),
                  iconColor: const Color(0xFFC6A326),
                  onTap: onMicTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!isPreviewReady || engine == null) {
      return Container(
        color: const Color(0xFFD9D9D9),
        alignment: Alignment.center,
        child: const CustomText(
          text: 'جاري تجهيز المعاينة...',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (!isCameraOn) {
      return Container(
        color: const Color(0xFF202020),
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off_rounded, color: Colors.white70, size: 52),
            SizedBox(height: 10),
            CustomText(
              text: 'الكاميرا متوقفة',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }
}

class _CircleControlButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Future<void> Function() onTap;

  const _CircleControlButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 76,
          height: 76,
          child: Icon(icon, color: iconColor, size: 34),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16, color: Color(0xFF202020)),
      decoration: InputDecoration(
        hintText: hintText,
        hintTextDirection: TextDirection.rtl,
        hintStyle: const TextStyle(color: Color(0xFFB7B7B7), fontSize: 16),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: maxLines == 1 ? 18 : 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFE3E3E3), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.4),
        ),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE3E3E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CustomText(
            text: 'نصائح للبث المباشر',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 14),
          _TipText(text: 'تأكد من اتصال إنترنت قوي ومستقر'),
          SizedBox(height: 10),
          _TipText(text: 'اختر مكانًا بإضاءة جيدة'),
          SizedBox(height: 10),
          _TipText(text: 'تحدث بوضوح وبصوت مسموع'),
          SizedBox(height: 10),
          _TipText(text: 'أظهر المنتجات بوضوح للمشاهدين'),
        ],
      ),
    );
  }
}

class _TipText extends StatelessWidget {
  final String text;

  const _TipText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: CustomText(
            text: '•',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF3E3E3E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomText(
            text: text,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF3E3E3E),
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
