import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/main.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Dropdown values
  String? selectedCountry;
  String? selectedCity;
  String? selectedDistrict;

  // Product type checkboxes
  bool isSheepSelected = true;
  bool isAccessoriesSelected = false;

  // Breed chips
  List<String> selectedBreeds = ['بلدي'];
  final List<String> breeds = ['نقش', 'حري', 'سواش', 'تعتيق'];

  // Gender chips
  List<String> selectedMaleBreeds = ['بلدي'];
  List<String> selectedFemaleBreeds = [];
  final List<String> genderBreeds = ['بلدي'];

  // Price range
  TextEditingController minPriceController = TextEditingController(text: '500');
  TextEditingController maxPriceController = TextEditingController();

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 15),
              width: 40,
              height: 6,
              decoration: BoxDecoration(
                color: Color(0xff999999),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: CustomText(
              text: 'تصفية المنتجات',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          SizedBox(height: hi * 0.02),
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Dropdowns
                  _buildLocationSection(),

                  const SizedBox(height: 24),

                  // Product Type
                  _buildProductTypeSection(),

                  const SizedBox(height: 24),

                  _buildBreedsSection(),

                  const SizedBox(height: 24),

                  // Price Range
                  _buildPriceRangeSection(),

                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtons(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        CustomDropdownField(
          label: 'الدولة',
          value: selectedCountry,
          hint: 'الكويت',
          items: ['الكويت', 'السعودية', 'الإمارات', 'البحرين'],
          onChanged: (value) {
            setState(() {
              selectedCountry = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CustomDropdownField(
          label: 'المنطقة',
          value: selectedCity,
          hint: 'الحمراء',
          items: ['الحمراء', 'الجهراء', 'الفروانية', 'حولي'],
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CustomDropdownField(
          label: 'المدينة / الحي',
          value: selectedDistrict,
          hint: 'الجابرية',
          items: ['الجابرية', 'السالمية', 'الشويخ', 'الصليبخات'],
          onChanged: (value) {
            setState(() {
              selectedDistrict = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildProductTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع المنتج',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        _buildCheckboxItem('غنم', isSheepSelected, (value) {
          setState(() {
            isSheepSelected = value ?? false;
          });
        }),
        const SizedBox(height: 3),
        _buildCheckboxItem('إكسسوارات', isAccessoriesSelected, (value) {
          setState(() {
            isAccessoriesSelected = value ?? false;
          });
        }),
      ],
    );
  }

  Widget _buildCheckboxItem(
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 5),

        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildBreedsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السلالة',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children:
              breeds.map((breed) {
                final isSelected = selectedBreeds.contains(breed);
                return _buildChip(breed, isSelected, () {
                  setState(() {
                    if (isSelected) {
                      selectedBreeds.remove(breed);
                    } else {
                      selectedBreeds.add(breed);
                    }
                  });
                });
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5B135) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.primary : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السعر',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'من',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: minPriceController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5B135),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: wi * 0.08),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إلى',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: maxPriceController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    decoration: InputDecoration(
                      hintText: 'أدخل الحد الأقصى',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5B135),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Clear all filters
              setState(() {
                selectedCountry = null;
                selectedCity = null;
                selectedDistrict = null;
                isSheepSelected = false;
                isAccessoriesSelected = false;
                selectedBreeds.clear();
                selectedMaleBreeds.clear();
                selectedFemaleBreeds.clear();
                minPriceController.clear();
                maxPriceController.clear();
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: CustomText(
              text: 'مسح الكل',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              // Apply filters
              Navigator.pop(context, {
                'country': selectedCountry,
                'city': selectedCity,
                'district': selectedDistrict,
                'isSheep': isSheepSelected,
                'isAccessories': isAccessoriesSelected,
                'breeds': selectedBreeds,
                'maleBreeds': selectedMaleBreeds,
                'femaleBreeds': selectedFemaleBreeds,
                'minPrice': minPriceController.text,
                'maxPrice': maxPriceController.text,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: CustomText(
              text: 'تطبيق الفلتر',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Dropdown Field that opens a Dialog
class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showSelectionDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? hint,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: value != null ? Colors.grey[800] : Colors.grey[400],
                  ),
                ),
                Center(child: SvgPicture.asset(AppAssets.dropDown)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Title
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5B135).withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text(
                        'اختر $label',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                ),

                // Items List
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder:
                        (context, index) =>
                            Divider(height: 1, color: Colors.grey[200]),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = value == item;

                      return ListTile(
                        title: Text(
                          item,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color:
                                isSelected
                                    ? const Color(0xFFE5B135)
                                    : Colors.grey[800],
                          ),
                        ),
                        trailing:
                            isSelected
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFFE5B135),
                                  size: 20,
                                )
                                : null,
                        onTap: () {
                          onChanged(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Function to show the bottom sheet
void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterBottomSheet(),
  ).then((filters) {
    if (filters != null) {
      print('Filters applied: $filters');
    }
  });
}
