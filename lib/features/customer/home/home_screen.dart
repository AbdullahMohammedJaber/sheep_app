import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/managment/auction/customer/auction_customer_cubit.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/managment/product/customer/product_customer_cubit.dart';
import 'package:sheep/managment/shop/customer/shop_customer_cubit.dart';

import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/features/customer/home/best_shops.dart';
import 'package:sheep/features/customer/home/item_title_bar.dart';
import 'package:sheep/features/customer/home/last_auctions.dart';
import 'package:sheep/features/customer/home/last_live_auction.dart';
import 'package:sheep/features/customer/home/new_product.dart';
import 'package:sheep/main.dart';

class HomeScreenCustomer extends StatefulWidget {
  const HomeScreenCustomer({super.key});

  @override
  State<HomeScreenCustomer> createState() => _HomeScreenCustomerState();
}

class _HomeScreenCustomerState extends State<HomeScreenCustomer> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_initialized) return;
    _initialized = false;

    await Future.wait([
      context.read<AuctionCustomerCubit>().fetchAuctions(refresh: true),
      context.read<ProductCustomerCubit>().fetchProducts(refresh: true),
      context.read<ShopCustomerCubit>().fetchShops(refresh: true),
      context.read<AuctionCustomerCubit>().fetchLiveAuctions(refresh: true),
    ]);
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1),

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: hi * 0.02),

              ItemTitleBar(),

              Divider(color: AppColors.border, thickness: 1),

              SizedBox(height: hi * 0.03),

              LastAuctions(),

              if (HelperAuth().getLogin())
                Column(
                  children: [SizedBox(height: hi * 0.03), LastLiveAuctions()],
                ),
              if (HelperAuth().getLogin())
                Column(children: [SizedBox(height: hi * 0.03), BestShops()]),

              SizedBox(height: hi * 0.03),

              NewProduct(),

              SizedBox(height: hi * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
