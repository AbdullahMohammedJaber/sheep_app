import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/features/live/live_brodcast_seller.dart';
import 'package:sheep/features/live/live_create.dart';
import 'package:sheep/managment/live/live_seller_cubit.dart';
import 'package:sheep/managment/live/live_seller_state.dart';

class SellerLiveFlowPage extends StatelessWidget {
  const SellerLiveFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SellerLiveCubit()..initPreview(),
      child: BlocBuilder<SellerLiveCubit, SellerLiveState>(
        builder: (context, state) {
          final isLiveScreen =
              state.status == SellerLiveStatus.live && state.isJoined;

          if (isLiveScreen) {
            return const SellerLiveBroadcastPage();
          }

          return const LiveCreatePage();
        },
      ),
    );
  }
}