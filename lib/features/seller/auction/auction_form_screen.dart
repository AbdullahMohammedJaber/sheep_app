import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/features/seller/auction/auction_form_view.dart';
import 'package:sheep/managment/auction/seller/auction_form_cubit.dart';

 

class AuctionFormScreen extends StatelessWidget {
  const AuctionFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuctionFormCubit(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0,),
        body: const SafeArea(
          child: AuctionFormView(),
        ),
      ),
    );
  }
}