class ProductFormInitialData {
  final String? productId;

  final String title;
  final String description;
  final String location;
  final String price;
  final String age;
  final String weight;

  final String selectedCategory;
  final String selectedBreed;

  final int selectedImagesCount;

  const ProductFormInitialData({
    this.productId,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.age,
    required this.weight,
    required this.selectedCategory,
    required this.selectedBreed,
    required this.selectedImagesCount,
  });
}