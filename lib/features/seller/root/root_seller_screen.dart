// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/managment/root/root_cubit.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/enum.dart';

class RootSellerScreen extends StatefulWidget {
  const RootSellerScreen({super.key});

  @override
  State<RootSellerScreen> createState() => _RootSellerScreenState();
}

class _RootSellerScreenState extends State<RootSellerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RootCubit>().onClickBottomIconSeller(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootCubit, RootState>(
      builder: (context, state) {
        final cubit = context.watch<RootCubit>();

        return Scaffold(
          appBar: AppBar(toolbarHeight: 1),
          body: cubit.screensSeller[state.currenPage],
          bottomNavigationBar: Container(
            height: hi * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 1, color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(cubit.iconsSeller.length, (index) {
                  if (cubit.iconsSeller[index].id == 2 &&
                      HelperAuth().getUser()!.data!.role ==
                          UserRole.AccessoryVendor.name) {
                    return SizedBox();
                  }
                  return GestureDetector(
                    onTap: () {
                      cubit.onClickBottomIconSeller(
                        cubit.iconsSeller[index].id,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width:
                          cubit.iconsSeller[index].id == state.currenPage
                              ? wi * 0.2
                              : wi * 0.15,
                      height: hi * 0.05,
                      decoration: BoxDecoration(
                        color:
                            cubit.iconsSeller[index].select
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          cubit.iconsSeller[index].path,
                          height: 25,
                          color:
                              cubit.iconsSeller[index].select
                                  ? AppColors.primary
                                  : null,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
