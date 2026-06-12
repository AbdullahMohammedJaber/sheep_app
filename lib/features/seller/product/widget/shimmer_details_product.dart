import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final hi = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// 🔥 SliverAppBar Shimmer
            SliverAppBar(
              expandedHeight: hi * 0.3,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,

              actions: [
                const SizedBox(width: 12),
                _circle(),
                const Spacer(),
                _circle(),
              ],

              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.grey.shade300,
                ),
              ),
            ),

            /// 🔥 Content Shimmer
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 200, height: 20),
                    const SizedBox(height: 12),

                    _line(width: 150, height: 16),
                    const SizedBox(height: 20),

                    _box(height: 80),
                    const SizedBox(height: 16),

                    _box(height: 80),
                    const SizedBox(height: 16),

                    _box(height: 120),
                    const SizedBox(height: 16),

                    _line(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    _line(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    _line(width: 200, height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Line shimmer
  Widget _line({double width = double.infinity, double height = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  /// 🔹 Box shimmer
  Widget _box({double height = 100}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// 🔹 Circle shimmer (buttons)
  Widget _circle() {
    return Container(
      height: 40,
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}