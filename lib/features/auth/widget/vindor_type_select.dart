import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/managment/auth/auth_cubit.dart';
import 'package:sheep/managment/auth/auth_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/enum.dart';

class VendorTypeSelector extends StatelessWidget {
  const VendorTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "التسجيل ك",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
          
           
              _item(
                title: "بائع مزارع / شيك / مزرعة",
                selected: state.userRole == UserRole.SheepVendor,
                onTap: () {
                  print("object");
                  context.read<AuthCubit>().selectVendorType(UserRole.SheepVendor);
                },
              ),
          
              const SizedBox(height: 10),
          
             
              _item(
                title: "بائع إكسسوارات",
                selected: state.userRole == UserRole.AccessoryVendor,
                onTap: () {
                  context.read<AuthCubit>().selectVendorType(UserRole.AccessoryVendor);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _item({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        /// checkbox
        GestureDetector(
           onTap: onTap,
           
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey),
            ),
            child: selected
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ),
    
        const SizedBox(width: 10),
    
        /// text
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}