import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_form_faild.dart';
 import 'package:sheep/features/auth/widget/widget_auth.dart';
import 'package:sheep/features/customer/store/shop/widget/status_search_shop.dart';
 import 'package:sheep/main.dart';

class AllShopsScreen extends StatefulWidget {
  const AllShopsScreen({super.key});

  @override
  State<AllShopsScreen> createState() => _AllShopsScreenState();
}

class _AllShopsScreenState extends State<AllShopsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: hi * 0.01, width: double.infinity),

                arrowLift(context, "أسواق"),

                SizedBox(height: hi * 0.02),

                _buildSearchBar(),

                SizedBox(height: hi * 0.03),

                const Divider(thickness: 2, color: AppColors.border),
              ],
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: _StatusSelectorDelegate(
              child: ShopsStatusSelector(onChanged: (status) {}),
            ),
          ),

          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          //   sliver: SliverGrid(
          //     delegate: SliverChildBuilderDelegate((context, index) {
          //       return ShopItem();
          //     }, childCount: 10),
          //     gridDelegate:  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          //       crossAxisCount: 2,
          //       mainAxisSpacing: 5,
          //       crossAxisSpacing: 2,
          //       height: hi * 0.46,
          //     ),
          //   ),
          // ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              hint: "ابحث",
              keyboardType: TextInputType.name,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [SvgPicture.asset(AppAssets.searchNormal)],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 55,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: SvgPicture.asset(AppAssets.filter)),
      ),
    );
  }
}

class _StatusSelectorDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _StatusSelectorDelegate({required this.child});

  @override
  double get minExtent => 70;

  @override
  double get maxExtent => 70;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      alignment: Alignment.center,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StatusSelectorDelegate oldDelegate) {
    return false;
  }
}
