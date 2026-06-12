// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/features/auth/login.dart';
import 'package:sheep/features/auth/widget/dialog_auth.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/managment/root/root_cubit.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/route.dart';

class RootCustomerScreen extends StatefulWidget {
  const RootCustomerScreen({super.key});

  @override
  State<RootCustomerScreen> createState() => _RootCustomerScreenState();
}

class _RootCustomerScreenState extends State<RootCustomerScreen> {
  @override
  void initState() {
    context.read<RootCubit>().onClickBottomIcon(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootCubit, RootState>(
      builder: (context, state) {
        final cubit = context.watch<RootCubit>();

        return Scaffold(
          appBar: AppBar(toolbarHeight: 1),
          body: cubit.screensCustomer[state.currenPage],
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
                ...List.generate(cubit.iconsCustomer.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (cubit.iconsCustomer[index].id == 2) {
                        if (HelperAuth().getLogin()) {
                          cubit.onClickBottomIcon(
                            cubit.iconsCustomer[index].id,
                          );
                        } else {
                          showLoginRequiredDialog(
                            context: context,
                            onLogin: () {
                              toRemoveAll(LoginScreen());
                            },
                          );
                        }
                      } else {
                        cubit.onClickBottomIcon(cubit.iconsCustomer[index].id);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width:
                          cubit.iconsCustomer[index].id == state.currenPage
                              ? wi * 0.2
                              : wi * 0.13,
                      height: hi * 0.05,
                      decoration: BoxDecoration(
                        color:
                            cubit.iconsCustomer[index].select
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          cubit.iconsCustomer[index].path,
                          color:
                              cubit.iconsCustomer[index].select
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
