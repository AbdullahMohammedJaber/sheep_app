import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/features/seller/home/actions_section.dart';
import 'package:sheep/features/seller/home/analyze_data_widget.dart';
import 'package:sheep/features/seller/home/item_title_bar.dart';
import 'package:sheep/features/seller/home/new_product_seller.dart';
import 'package:sheep/main.dart';

class HomeScreenSeller extends StatefulWidget {
  const HomeScreenSeller({super.key});

  @override
  State<HomeScreenSeller> createState() => _HomeScreenSellerState();
}

class _HomeScreenSellerState extends State<HomeScreenSeller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1),
      body: RefreshIndicator(
        onRefresh: () {
          return context.read<HomeSellerCubit>().fetchMyProducts(refresh: true);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: hi * 0.02),
              ItemTitleBarSeller(),
              Divider(color: AppColors.border, thickness: 1),
              SizedBox(height: hi * 0.03),
              AnalyzeDataWidget(),
              SizedBox(height: hi * 0.03),
              QuickActionsSection(),
              SizedBox(height: hi * 0.03),
              NewProductSeller(),
              SizedBox(height: hi * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
