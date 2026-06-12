// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/widgets/custom_text.dart';
class HeaderShopImage extends StatelessWidget {
  final String? coverImage;
  final String? logoImage;
  final String? storeName;

  const HeaderShopImage({
    super.key,
    this.coverImage,
    this.logoImage,
    this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
 
            Container(
              height: 160,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: NetworkImage(
                    coverImage ??
                        "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          
            Positioned(
              right: 24,
              top: 10,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.arrowLeft,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "بروفايل البائع",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

       
            Positioned(
              bottom: -50, 
              right: 24,
              left: 24,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage:
                          logoImage != null && logoImage!.isNotEmpty
                              ? NetworkImage(logoImage!)
                              : const AssetImage("assets/images/test2.png")
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 50,
                      color: Colors.transparent,
                      alignment: Alignment.bottomRight,
                      child: CustomText(
                        text: storeName ?? "متجر",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

     
        const SizedBox(height: 50),
      ],
    );
  }
}