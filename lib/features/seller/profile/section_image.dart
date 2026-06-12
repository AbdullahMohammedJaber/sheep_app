import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/main.dart';

class SectionImageSeller extends StatelessWidget {
  const SectionImageSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: hi * 0.2,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            child: Container(
              height: hi * 0.12,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                border: Border.all(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: "مرحبا , ${HelperAuth().getUser()?.data?.fullname}",
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                     
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _showImagePickerOptions(context);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.transparent,
                        child: Center(child: SvgPicture.asset(AppAssets.edit)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://picsum.photos/300/300',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
 
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'تغيير صورة الملف الشخصي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFE5B135)),
                title: const Text('التقاط صورة'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFFE5B135),
                ),
                title: const Text('اختيار من المعرض'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement gallery picker
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
