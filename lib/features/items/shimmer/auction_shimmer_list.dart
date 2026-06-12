import 'package:flutter/material.dart';
import 'package:sheep/features/items/shimmer/auction_c_shimmer.dart';

class AuctionsShimmerList extends StatelessWidget {
  final Axis scroll; 
  const AuctionsShimmerList({super.key ,   this.scroll = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: scroll,
        itemCount: 5,
        itemBuilder: (_, __) => const AuctionItemShimmer(),
      ),
    );
  }
}