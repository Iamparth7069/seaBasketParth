import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/dic_params.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/base/utils/image_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/base/utils/progress_dialog_utils.dart';
import 'package:seabasket/src/controllers/category_controller.dart';
import 'package:seabasket/src/controllers/product_controller.dart';
import 'package:seabasket/src/models/category/category_model.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/providers/bottom_nav_provider.dart';
import 'package:seabasket/src/providers/category_provider.dart';
import 'package:seabasket/src/providers/product_provider.dart';
import 'package:seabasket/src/ui//home/filter_bottomsheet.dart';
import 'package:seabasket/src/widgets/incrementally_loading_listview.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  static const List<ProductSortType?> _sortOptions = [
    null,
    ProductSortType.priceLowToHigh,
    ProductSortType.priceHighToLow,
    ProductSortType.relevance,
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        final productController = locator<ProductController>();
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          if (productController.hasMore && !productController.isLoading) {
            _fetchProducts(loadMore: true);
          }
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHomeData());
  }

  Future<void> _loadHomeData() async {
    final provider = context.read<ProductProvider>();
    // Skip calling API if products are already loaded (e.g. returning from another tab)
    if (provider.products.isNotEmpty) return;

    ProgressDialogUtils.showProgressDialog();
    final categories = await locator<CategoryController>().getAllCategories();
    final products = await locator<ProductController>().getProducts(
      loadMore: false,
      categoryId: provider.selectedCategoryId,
      minPrice: provider.priceRange.start,
      maxPrice: provider.priceRange.end,
      minRating: provider.selectedRating,
      discounts: provider.selectedDiscounts,
      sort: _sortOptions[provider.selectedSortIndex],
    );
    if (!mounted) return;
    if (categories != null) {
      context.read<CategoryProvider>().setCategories(categories);
    }
    if (products != null) context.read<ProductProvider>().setProducts(products);
    ProgressDialogUtils.dismissProgressDialog();
  }

  Future<void> _fetchProducts({bool loadMore = false}) async {
    final controller = locator<ProductController>();
    final provider = context.read<ProductProvider>();
    if (!loadMore) {
      ProgressDialogUtils.showProgressDialog();
    }

    final result = await controller.getProducts(
      loadMore: loadMore,
      categoryId: provider.selectedCategoryId,
      minPrice: provider.priceRange.start,
      maxPrice: provider.priceRange.end,
      minRating: provider.selectedRating,
      discounts: provider.selectedDiscounts,
      sort: _sortOptions[provider.selectedSortIndex],
    );

    ProgressDialogUtils.dismissProgressDialog();
    if (result != null && mounted && result.isNotEmpty) {
      context.read<ProductProvider>().setProducts(result, append: loadMore);
    }
    provider.updateHasMore(controller.hasMore);
  }

  void openFilterBottomSheet(BuildContext context) async {
    context.read<ProductProvider>().openFilterSheet();

    final result = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      builder: (context) {
        return const FilterBottomSheet();
      },
    );
    if (result == true) {
      locator<ProductController>().resetPage();
      context.read<ProductProvider>().setProducts([]);
      _fetchProducts();
    }
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
            hint: Localization.of().searchHintText,
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
                color: isSelected ? primaryColor : secondaryColor.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: containerBorderColor.withAlpha(100)),
              ),
              child: InkWell(
                onTap: () {
                  categoryProvider.selectCategory(index);
                  final categoryId =
                      index == 0 ? null : categories[index - 1].id;
                  context
                      .read<ProductProvider>()
                      .setSelectedCategory(categoryId);

                  locator<ProductController>().resetPage();
                  context.read<ProductProvider>().setProducts([]);

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
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products;
        if (productProvider.isLoading && products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (products.isEmpty) {
          return Center(
            child: Text(Localization.of().noProductFoundText),
          );
        }
        const crossAxisCount = 2;
        int rowCount = (products.length / crossAxisCount).ceil();
        if (productProvider.hasMore) {
          rowCount += 1;
        }

        return IncrementallyLoadingListView(
          controller: _scrollController,
          shrinkWrap: true,
          hasMore: () => productProvider.hasMore,
          loadMore: () async {
            await _fetchProducts(loadMore: true);
          },
          itemCount: () => rowCount,
          itemBuilder: (context, rowIndex) {
            if (productProvider.hasMore && rowIndex == rowCount - 1) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            final firstIndex = rowIndex * crossAxisCount;
            final secondIndex = firstIndex + 1;

            return Row(
              children: [
                if (firstIndex < products.length)
                  Expanded(child: _productItem(products[firstIndex])),
                if (secondIndex < products.length)
                  Expanded(child: _productItem(products[secondIndex])),
                if (secondIndex >= products.length)
                  Expanded(child: Container()),
              ],
            );
          },
        );
      },
    );
  }

  Widget _productItem(ProductModel product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
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
          const SizedBox(height: 6),
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
              const SizedBox(width: 7),
              Text(
                "-${product.discountPercentage?.round()}%  ${(product.discountedPrice)}",
                style: const TextStyle(
                  color: discountPriceColor,
                  fontSize: fontSize12,
                  fontWeight: fontWeightMedium,
                  height: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              const Icon(
                Icons.star_outlined,
                size: fontSize14,
                color: fillRatingIconColor,
              ),
              Text(
                "${product.averageRating}",
                style: const TextStyle(
                  color: primaryTextColor,
                  fontSize: fontSize12,
                  fontWeight: fontWeightMedium,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
