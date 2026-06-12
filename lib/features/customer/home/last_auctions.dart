import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/features/items/shimmer/auction_shimmer_list.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:sheep/managment/root/root_cubit.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/items/auction_items.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class LastAuctions extends StatefulWidget {
  const LastAuctions({super.key});

  @override
  State<LastAuctions> createState() => _LastAuctionsState();
}

class _LastAuctionsState extends State<LastAuctions> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<AuctionCustomerCubit>();

     
    cubit.fetchAuctions(refresh: true, overrideStatus: AuctionStatus.active);

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        cubit.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "المزادات الجارية",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff363D4E),
              ),

              GestureDetector(
                onTap: () {
                  context.read<RootCubit>().onClickBottomIcon(1);
                },
                child: Row(
                  children: [
                    const CustomText(
                      text: "عرض الكل",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(child: SvgPicture.asset(AppAssets.go)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: hi * 0.02),

         BlocBuilder<AuctionCustomerCubit, AuctionsCustomerState>(
          builder: (context, state) {
            final auctions = state.auctions;

            if (state.isLoading) {
              return const AuctionsShimmerList();
            }

            if (state.error != null) {
              return AppErrorWidget(
                onRetry: () {
                  context.read<AuctionCustomerCubit>().fetchAuctions(
                    refresh: true,
                    overrideStatus: AuctionStatus.active,
                  );
                },
                title: AppStrings.error_try,
              );
            }
            if (state.auctions.isEmpty) {
              return CustomText(text: AppStrings.noDataAuction);
            }
            return SizedBox(
              height: hi * 0.5,

              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(start: 12),

                itemCount: auctions.length + (state.hasMore ? 1 : 0),

                itemBuilder: (context, index) {
                  if (index == auctions.length) {
                    if (state.isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return const SizedBox(width: 60);
                  }

                  final auction = auctions[index];

                  return AuctionItem(auctionCustomer: auction);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
