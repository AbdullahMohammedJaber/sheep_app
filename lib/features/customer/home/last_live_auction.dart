import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/features/items/auction_item_live.dart';
 import 'package:sheep/features/items/shimmer/auction_shimmer_list.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
  import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
 
import 'package:sheep/util/widgets/custom_text.dart';
 
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class LastLiveAuctions extends StatefulWidget {
  const LastLiveAuctions({super.key});

  @override
  State<LastLiveAuctions> createState() => _LastLiveAuctionsState();
}

class _LastLiveAuctionsState extends State<LastLiveAuctions> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<AuctionCustomerCubit>();

     
    cubit.fetchLiveAuctions(refresh: true);

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
              CustomText(
                text: "البثوث المباشرة",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff363D4E),
              ),

              Row(
                children: [
                  CustomText(
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
            ],
          ),
        ),
        SizedBox(height: hi * 0.02),
         BlocBuilder<AuctionCustomerCubit, AuctionsCustomerState>(
          builder: (context, state) {
            final auctions = state.liveAuctions;

            if (state.isLiveLoading) {
              return const AuctionsShimmerList();
            }

            if (state.liveError != null) {
              return AppErrorWidget(
                onRetry: () {
                  context.read<AuctionCustomerCubit>().fetchLiveAuctions(
                    refresh: true,
                   
                  );
                },
                title: AppStrings.error_try,
              );
            }
            if (state.liveAuctions.isEmpty) {
              return CustomText(text: AppStrings.noDataAuction);
            }
            return SizedBox(
              height: hi * 0.42,

              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(start: 12),
                
                itemCount: auctions.length + (state.hasMoreLive ? 1 : 0),

                itemBuilder: (context, index) {
                  if (index == auctions.length) {
                    if (state.isLiveLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return const SizedBox(width: 60);
                  }

                  final auction = auctions[index];

                  return AuctionItemLive(auctionCustomer: auction);
                },
              ),
            );
          },
        ),
        
      ],
    );
  }
}
