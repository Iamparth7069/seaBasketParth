import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/dialog_utils.dart';
import 'package:seabasket/src/base/utils/image_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/controllers/cart_controller.dart';
import 'package:seabasket/src/controllers/product_controller.dart';
import 'package:seabasket/src/models/cart/cart_model.dart';
import 'package:seabasket/src/models/product/product_model.dart';
import 'package:seabasket/src/models/request/req_cart_model.dart';
import 'package:seabasket/src/models/response/res_product_detail_model.dart';
import 'package:seabasket/src/providers/bottom_nav_provider.dart';
import 'package:seabasket/src/providers/cart_provider.dart';
import 'package:seabasket/src/providers/product_provider.dart';
import 'package:seabasket/src/providers/user_provider.dart';
import 'package:seabasket/src/widgets/primary_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedSizeIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _loadProduct();
      },
    );
  }

  Future<void> _loadProduct() async {
    await locator<ProductController>()
        .getProductById(context, widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final productDetail =
        context.select<ProductProvider, ResProductDetailModel?>(
      (p) => p.selectedProduct,
    );
    if (productDetail?.data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final product = productDetail!.data!.product!;
    final size = productDetail.data?.availableSizes ?? [];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _productImage(product),
                  const SizedBox(height: 10),
                  _productInfo(product, size!),
                  const SizedBox(height: 2),
                  Text(
                    Localization.of().priceText,
                    style: const TextStyle(
                      fontSize: fontSize16,
                      color: secondaryTextColor,
                      fontWeight: fontWeightRegular,
                    ),
                  ),
                  Text(
                    "\₹${product.price ?? 0.0}",
                    style: const TextStyle(
                      fontSize: fontSize24,
                      color: primaryTextColor,
                      fontWeight: fontWeightSemiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
        _bottomSection(product, size),
      ],
    ).commonScaffold(
        context: context,
        title: Localization.of().detailsText,
        centerTitle: true,
        leading: IconButton(
            onPressed: locator<NavigationUtils>().pop,
            icon: const Icon(Icons.arrow_back)));
  }

  Widget _productImage(ProductModel product) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: ImageUtils(
          base64String: product.imageUrl,
          fit: BoxFit.cover,
          fillHeight: false,
        ));
  }

  Widget _productInfo(ProductModel product, List<String> size) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name ?? "",
              style: const TextStyle(fontSize: 22, fontWeight: fontWeightBold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 18),
                const SizedBox(width: 6),
                Text(
                  "${product.averageRating ?? 0.0}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.description ?? "",
              style: const TextStyle(
                  fontSize: fontSize16,
                  fontWeight: fontWeightRegular,
                  color: secondaryTextColor),
            ),
            const SizedBox(height: 13),
            Text(
              Localization.of().chooseSizeText,
              style: const TextStyle(fontSize: 22, fontWeight: fontWeightBold),
            ),
            const SizedBox(height: 12),
            Row(
                children: List.generate(
              size.length,
              (index) {
                final isSelected = productProvider.selectedSizeIndex == index;
                return GestureDetector(
                  onTap: () {
                    locator<ProductController>().onSizeSelected(context, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 11),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? primaryButtonColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isSelected
                              ? primaryButtonColor
                              : containerBorderColor),
                    ),
                    child: Text(
                      size[index],
                      style: TextStyle(
                          fontSize: fontSize20,
                          color: isSelected ? secondaryColor : primaryTextColor,
                          fontWeight: fontWeightMedium),
                    ),
                  ),
                );
              },
            ))
          ],
        );
      },
    );
  }

  Widget _bottomSection(ProductModel product, List<String> size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Consumer3<ProductProvider, UserProvider, CartProvider>(
        builder: (context, productProvider, userProvider, cartProvider, child) {
          final selectedSize =
              size.isNotEmpty ? size[productProvider.selectedSizeIndex] : null;
          final isAlreadyInCart =
              cartProvider.isInCart(product.id, selectedSize);

          return PrimaryButton(
            buttonText: isAlreadyInCart
                ? Localization.of().goToCartText
                : Localization.of().addToCartText,
            buttonColor: primaryButtonColor,
            backgroundColor: primaryButtonColor,
            textColor: secondaryColor,
            leadingIcon: Icons.shopping_bag_outlined,
            onButtonClick: productProvider.isAddingToCart
                ? null
                : () async {
                    if (!userProvider.isLoggedIn) {
                      _showLoginDialog();
                      return;
                    }
                    if (isAlreadyInCart) {
                      locator<NavigationUtils>().pop();
                      locator<ProductController>().goToCart(context);
                    } else {
                      await _handleAddToCart(product, selectedSize);
                    }
                  },
          );
        },
      ),
    );
  }

  void _showLoginDialog() {
    showAlertDialog(
      isCancelEnable: true,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, color: primaryColor, size: 80),
            const SizedBox(height: 12),
            Text(
              Localization.of().loginAlertMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: fontSize14,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              buttonText: Localization.of().loginText,
              buttonColor: primaryButtonColor,
              backgroundColor: primaryButtonColor,
              textColor: secondaryColor,
              onButtonClick: () {
                locator<NavigationUtils>().pop();
                locator<NavigationUtils>().push(routeLogin);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddToCart(
    ProductModel product,
    String? selectedSize,
  ) async {
    final success = await locator<CartController>().addProductToCart(
      context: context,
      product: product,
      size: selectedSize,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${product.name ?? ''} ${Localization.of().addedCartText}',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
