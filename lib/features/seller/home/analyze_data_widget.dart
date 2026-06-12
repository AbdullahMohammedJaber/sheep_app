// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/managment/home/seller/home_seller_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';
import 'package:shimmer/shimmer.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: hi * 0.18,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, width: width * 0.07, color: iconColor),

          const SizedBox(height: 12),

          Text(
            title,
            style: TextStyle(
              fontSize: width * 0.035,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyzeDataWidget extends StatefulWidget {
  const AnalyzeDataWidget({super.key});

  @override
  State<AnalyzeDataWidget> createState() => _AnalyzeDataWidgetState();
}

class _AnalyzeDataWidgetState extends State<AnalyzeDataWidget> {
  @override
  void initState() {
    super.initState();

    final cubit = context.read<HomeSellerCubit>();

    cubit.detailsSeller();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeSellerCubit, HomeSellerState>(
      builder: (context, state) {
        if (state.dataSellerRequestStatus == RequestStatus.loading) {
          return const DashboardStatCardShimmer();
        }

        if (state.dataSellerRequestStatus == RequestStatus.failure) {
          return Center(child: Text(state.error ?? AppStrings.error_try));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: DashboardStatCard(
                  title: "المزادات",
                  value:
                      state.dataSellerResponse!.data!.allAuctions!.toString(),
                  icon: AppAssets.auction,
                  backgroundColor: const Color(0xffF3EDE2),
                  iconColor: const Color(0xffC8A33D),
                  textColor: const Color(0xffC8A33D),
                ),
              ),

              SizedBox(width: wi * 0.03),

              Expanded(
                child: DashboardStatCard(
                  title: "منتجاتي",
                  value: state.dataSellerResponse!.data!.productsCount!.toString(),
                  icon: AppAssets.product,
                  backgroundColor: const Color(0xffE5EDF4),
                  iconColor: const Color(0xff2B6CB0),
                  textColor: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardStatCardShimmer extends StatelessWidget {
  const DashboardStatCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            /// ================= CARD 1 =================
            Expanded(
              child: Container(
                height: hi * 0.18,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// icon placeholder
                    Container(
                      width: width * 0.07,
                      height: width * 0.07,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// title placeholder
                    Container(
                      height: 10,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// value placeholder
                    Container(
                      height: 16,
                      width: width * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: wi * 0.03),

            /// ================= CARD 2 =================
            Expanded(
              child: Container(
                height: hi * 0.18,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// icon placeholder
                    Container(
                      width: width * 0.07,
                      height: width * 0.07,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// title placeholder
                    Container(
                      height: 10,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    const SizedBox(height: 10),

                    
                    Container(
                      height: 16,
                      width: width * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}