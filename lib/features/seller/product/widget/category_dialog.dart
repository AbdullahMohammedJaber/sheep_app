import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/category/category_response.dart';
import 'package:sheep/features/seller/product/widget/category_option_tile.dart';
import 'package:sheep/managment/category/category_cubit.dart';
import 'package:sheep/managment/category/category_state.dart';
import 'package:sheep/util/enum.dart';

class CategoryDialog extends StatefulWidget {
  final Function(Category category) onSelected;

  const CategoryDialog({super.key, required this.onSelected});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  late final CategoryCubit cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    cubit = context.read<CategoryCubit>();

    cubit.fetchCategories(refresh: true);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      cubit.fetchCategories();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),

            const SizedBox(height: 20),

            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state.categoryStatus == RequestStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.categories.length +
                        (state.categoryHasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.categories.length) {
                        final category = state.categories[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CategoryOptionTile(
                            title: category.categoryName!,
                            isSelected: false,
                            onTap: () {
                              widget.onSelected(category);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      }

                      return const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختيار التصنيف',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF232323),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'اختر التصنيف المناسب لمنتجك',
                style: TextStyle(fontSize: 14, color: Color(0xFF7C7C7C)),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
