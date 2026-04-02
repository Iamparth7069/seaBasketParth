import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/dic_params.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/image_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/product_controller.dart';
import 'package:seabasket/src/providers/product_provider.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  String _activeQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _getSearchbarTextField(),
        ),
        const SizedBox(height: 12),
        Expanded(child: _searchResult()),
      ],
    );
  }

  Widget _getSearchbarTextField() {
    return PrimaryTextField(
      autoFocus: true,
      onChanged: (value) async {
        final provider = context.read<ProductProvider>();
        final query = value.trim();

        _activeQuery = query;
        provider.setSearchQuery(query);

        if (query.isEmpty) {
          provider.setProducts([]);
          provider.setSearching(false);
          return;
        }

        provider.setSearching(true);

        final result =
            await locator<ProductController>().getProducts(name: query);

        // Discard result if the user has already typed something newer
        if (_activeQuery != query) return;

        provider.setSearching(false);

        if (result != null) {
          provider.setProducts(result);
        } else {
          provider.setProducts([]);
        }
      },
      controller: searchController,
      label: "",
      hint: Localization.of().searchText,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(Icons.search),
    );
  }

  Widget _searchResult() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isSearching) {
          return const Center(child: CircularProgressIndicator());
        }
        if (productProvider.searchQuery.trim().isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_outlined,
                  size: 48, color: secondaryIconColor),
              const SizedBox(height: 12),
              Text(
                Localization.of().noResultFoundText,
                style: const TextStyle(
                  fontSize: fontSize18,
                  color: primaryTextColor,
                  fontWeight: fontWeightSemiBold,
                ),
              ),
              Text(
                Localization.of().noResultFoundSubText,
                style: const TextStyle(
                  fontSize: fontSize16,
                  color: secondaryTextColor,
                  fontWeight: fontWeightRegular,
                ),
              ),
            ],
          );
        }

        final products = productProvider.products;

        if (products.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 48, color: secondaryIconColor),
              const SizedBox(height: 12),
              Text(
                Localization.of().noResultFoundText,
                style: const TextStyle(
                  fontSize: fontSize18,
                  color: primaryTextColor,
                  fontWeight: fontWeightSemiBold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Localization.of().noResultFoundSubText,
                style: const TextStyle(
                  fontSize: fontSize14,
                  color: secondaryTextColor,
                  fontWeight: fontWeightRegular,
                ),
              ),
            ],
          );
        }

        return ListView.separated(
          separatorBuilder: (_, __) => const Divider(
            thickness: 0.5,
            color: secondaryTextColor,
            height: 1,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              dense: true,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: ImageUtils().getBase64Image(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                product.name ?? "",
                style: const TextStyle(
                  fontSize: fontSize14,
                  color: primaryTextColor,
                  fontWeight: fontWeightSemiBold,
                ),
              ),
              subtitle: Text(
                " ₹${product.price}",
                style: const TextStyle(
                  fontSize: fontSize12,
                  color: secondaryTextColor,
                  fontWeight: fontWeightRegular,
                ),
              ),
              trailing: const Icon(Icons.arrow_outward, size: 18),
              onTap: () {
                locator<NavigationUtils>().push(
                  routeProductDetails,
                  arguments: {paramProductId: product.id},
                );
              },
            );
          },
        );
      },
    );
  }
}
