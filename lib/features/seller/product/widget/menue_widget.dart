import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/category/breeds_response.dart'
    hide Data;
import 'package:sheep/core/data/response/category/category_response.dart'
    hide Data;
import 'package:sheep/core/data/response/product/details_product_seller.dart';
import 'package:sheep/features/seller/product/root_form_product_screen.dart';
import 'package:sheep/features/seller/product/widget/dialog_product.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/managment/product/seller/product_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';

void showProductMenu(BuildContext context, GlobalKey key, Data data) {
  final renderBox = key.currentContext!.findRenderObject() as RenderBox;
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
  final size = renderBox.size;

  showMenu(
    context: context,
    color: Colors.transparent,
    elevation: 0,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(position.dx, position.dy + size.height, 180, 100),
      Offset.zero & overlay.size,
    ),
    items: [
      PopupMenuItem(
        enabled: false,
        padding: EdgeInsets.zero,
        child: ProductMenu(data: data),
      ),
    ],
  );
}

class ProductMenu extends StatelessWidget {
  final Data data;
  const ProductMenu({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              showDeleteProductDialog(
                context: context,
                onConfirm: () {
                  context.read<HomeSellerCubit>().deleteProduct(
                    context,
                    data.id,
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 10),
                  CustomText(
                    text: "حذف المنتج",
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ),

          Divider(height: 1),

          InkWell(
            onTap: () {
              Navigator.pop(context);
              ToWithFade(
                context,
                ProductFormScreen.edit(
                  initialData: ProductFormInitialData(
                    productId: data.id!.toString(),
                    title: data.name!,
                    description: data.description!,
                    images: data.images!,
                    location: data.address!,
                    price: data.fixedPrice!.toString(),
                    age: data.age!.toString(),
                    weight: data.wight!.toString(),
                    selectedCategory: Category(
                      categoryName: data.categoryName,
                      id: int.parse(data.categoryId!.toString()),
                    ),
                    selectedBreed: Breeds(
                      breedName: data.breedName,
                      id: int.parse(data.breedId.toString()),
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.edit, color: AppColors.success),
                  SizedBox(width: 10),
                  CustomText(
                    text: "تعديل المنتج",
                    color: AppColors.success,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
