import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:sheep/features/seller/product/form_product_screen.dart';
import 'package:sheep/managment/product/seller/product_cubit.dart';
import 'package:sheep/managment/product/seller/product_state.dart';

 

class ProductFormScreen extends StatelessWidget {
  final ProductFormMode mode;
  final ProductFormInitialData? initialData;

  const ProductFormScreen.create({super.key})
      : mode = ProductFormMode.create,
        initialData = null;

  const ProductFormScreen.edit({
    super.key,
    required this.initialData,
  }) : mode = ProductFormMode.edit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductFormCubit(
        mode: mode,
        initialData: initialData,
      ),
      child: Scaffold(
         
        body: const SafeArea(
          child: ProductFormView(),
        ),
      ),
    );
  }
}