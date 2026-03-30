import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/dic_params.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/image_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/base/utils/image_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/base/utils/progress_dialog_utils.dart';
import 'package:seabasket/src/controllers/category_controller.dart';
import 'package:seabasket/src/controllers/product_controller.dart';
import 'package:seabasket/src/providers/bottom_nav_provider.dart';
import 'package:seabasket/src/providers/category_provider.dart';
import 'package:seabasket/src/providers/product_provider.dart';
import 'package:seabasket/src/ui//home/filter_bottomsheet.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';

import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  static const List<ProductSortType?> _sortOptions = [
    null,
    ProductSortType.priceLowToHigh,
    ProductSortType.priceHighToLow,
    ProductSortType.relevance,
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHomeData());
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
    });
    
    final provider = context.read<ProductProvider>();
    final results = await Future.wait([
      locator<CategoryController>().getAllCategories(),
      locator<ProductController>().getProducts(
        categoryId: provider.selectedCategoryId,
        minPrice: provider.priceRange.start,
        maxPrice: provider.priceRange.end,
        minRating: provider.selectedRating,
        sort: _sortOptions[provider.selectedSortIndex],
      ),
    ]);

    if (!mounted) return;
    
    if (results[0] != null) {
      context.read<CategoryProvider>().setCategories(results[0] as dynamic);
    }
    if (results[1] != null) {
      context.read<ProductProvider>().setProducts(results[1] as dynamic);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    
    final provider = context.read<ProductProvider>();
    final result = await locator<ProductController>().getProducts(
      categoryId: provider.selectedCategoryId,
      minPrice: provider.priceRange.start,
      maxPrice: provider.priceRange.end,
      minRating: provider.selectedRating,
      sort: _sortOptions[provider.selectedSortIndex],
    );
    
    if (result != null && mounted) {
      context.read<ProductProvider>().setProducts(result);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void openFilterBottomSheet(BuildContext context) async {
    context.read<ProductProvider>().openFilterSheet();
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      builder: (context) {
        return const FilterBottomSheet();
      },
    );
    if (mounted) _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.getWidth(0.04)),
          child: _getSearchbarTextField(),
        ),
        const SizedBox(height: 16),
        _getCategoryList(),
        const SizedBox(height: 16),
        Expanded(
          child: _getProductGrid(),
        ),
      ],
    );
  }

  Widget _getSearchbarTextField() {
    return Row(
      children: [
        Expanded(
          child: PrimaryTextField(
            readOnly: true,
            onTapped: () {
              context
                  .read<BottomNavProvider>()
                  .changeTab(1, fromHomeSearch: true);
            },
            controller: _searchController,
            label: "",
            hint: Localization.of().searchText,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () {
            openFilterBottomSheet(context);
          },
          child: Container(
            height: context.getWidth(0.12),
            width: context.getHeight(0.05),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune,
              color: secondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getCategoryList() {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.only(left: 13),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: 80,
                height: 40,
              );
            }),
          ),
        ),
      );
    }

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categories = categoryProvider.categories;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(categories.length + 1, (index) {
            final category =
                index == 0 ? "All" : categories[index - 1].name ?? "";
            final isSelected = categoryProvider.selectedCategoryIndex == index;
            return Container(
              margin: const EdgeInsets.only(left: 13),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? secondaryContainerColor
                    : primaryContainerColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: containerBorderColor),
              ),
              child: InkWell(
                onTap: () {
                  categoryProvider.selectCategory(index);
                  final categoryId =
                      index == 0 ? null : categories[index - 1].id;
                  context
                      .read<ProductProvider>()
                      .setSelectedCategory(categoryId);
                  _fetchProducts();
                },
                child: Text(category,
                    style: TextStyle(
                        fontSize: fontSize14,
                        color: isSelected ? secondaryColor : primaryTextColor)),
              ),
            );
          })),
        );
      },
    );
  }

  Widget _getProductGrid() {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: GridView.builder(
          padding: EdgeInsets.only(
            left: context.getWidth(0.04),
            right: context.getWidth(0.04),
            bottom: 20,
          ),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65),
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  color: Colors.white,
                  height: 14,
                  width: double.infinity,
                ),
                const SizedBox(height: 6),
                Container(
                  color: Colors.white,
                  height: 12,
                  width: context.getWidth(0.2),
                ),
              ],
            );
          },
        ),
      );
    }

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products;
        if (products.isEmpty) {
          return Center(
            child: Text(Localization.of().noProductFoundText),
          );
        }
        return GridView.builder(
          padding: EdgeInsets.only(
            left: context.getWidth(0.04),
            right: context.getWidth(0.04),
          ),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65),
          itemBuilder: (context, index) {
            final product = products[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          locator<NavigationUtils>().push(
                            routeProductDetails,
                            arguments: {paramProductId: product.id},
                          );
                        },
                        child: ImageUtils().getBase64Image(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  product.name ?? "",
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: fontSize14,
                    fontWeight: fontWeightExtraBold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "₹ ${product.price}",
                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: fontSize12,
                        fontWeight: fontWeightMedium,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      "-${product.discountPercentage?.round()}%",
                      style: const TextStyle(
                        color: discountPriceColor,
                        fontSize: fontSize12,
                        fontWeight: fontWeightMedium,
                        height: 1.4,
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
}
