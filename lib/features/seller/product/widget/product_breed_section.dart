import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/category/breeds_response.dart';
import 'package:sheep/features/seller/product/widget/section_title.dart';
import 'package:sheep/managment/category/category_cubit.dart';
import 'package:sheep/managment/category/category_state.dart';
import 'package:sheep/util/enum.dart';

class ProductBreedSection extends StatefulWidget {
  final String selectedBreed;
  final ValueChanged<Breeds> onBreedSelected;

  const ProductBreedSection({
    super.key,
    required this.selectedBreed,
    required this.onBreedSelected,
  });

  @override
  State<ProductBreedSection> createState() =>
      _ProductBreedSectionState();
}

class _ProductBreedSectionState
    extends State<ProductBreedSection> {
  late final ScrollController _scrollController;
  late final CategoryCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = context.read<CategoryCubit>();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

   
    cubit.fetchBreeds(refresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 150) {
      cubit.fetchBreeds();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    const border = Color(0xFFE7E7E7);
    const textColor = Color(0xFF2A2A2A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('السلالة'),
        const SizedBox(height: 14),

        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            final breeds = state.breeds;

            if (state.breedStatus == RequestStatus.loading &&
                breeds.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Wrap(
              spacing: 10,
              runSpacing: 12,
              children: [
                ...breeds.map((breed) {
                  final selected =
                      breed.breedName == widget.selectedBreed;

                  return GestureDetector(
                    onTap: () {
                      widget.onBreedSelected(breed);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFFFFBF0)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: selected ? gold : border,
                          width: 1.4,
                        ),
                      ),
                      child: Text(
                        breed.breedName!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected ? gold : textColor,
                        ),
                      ),
                    ),
                  );
                }),

                // ================= LOADING MORE =================
                if (state.breedHasMore)
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}