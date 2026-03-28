import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/string_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/providers/product_provider.dart';
import 'package:seabasket/src/widgets/primary_button.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Localization.of().filterText,
                style: const TextStyle(
                  fontSize: fontSize26,
                  color: primaryColor,
                  fontWeight: fontWeightBold,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: primaryColor,
                  size: 24,
                ),
                onPressed: () {
                  locator<NavigationUtils>().pop();
                },
              )
            ],
          ),
          Divider(
            thickness: 1.5,
            color: Colors.grey[400],
          ),
          Text(
            Localization.of().sortByText,
            style: const TextStyle(
              fontSize: fontSize18,
              color: primaryColor,
              fontWeight: fontWeightBold,
            ),
          ),
          const SizedBox(height: 10),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      List.generate(ProductSortType.values.length, (index) {
                    final isSelected = productProvider.tempSortIndex == index;

                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? secondaryContainerColor
                            : primaryContainerColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: containerBorderColor),
                      ),
                      child: InkWell(
                        onTap: () {
                          productProvider.selectSort(index);
                        },
                        child: Text(
                          ProductSortType.values[index].displayValue,
                          style: TextStyle(
                            fontSize: fontSize14,
                            color:
                                isSelected ? secondaryColor : primaryTextColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Consumer<ProductProvider>(
            builder: (context, homeProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Localization.of().priceText,
                    style: const TextStyle(
                      fontSize: fontSize18,
                      color: primaryColor,
                      fontWeight: fontWeightBold,
                    ),
                  ),
                  Text(
                    "₹${homeProvider.tempPriceRange.start} - ₹${homeProvider.tempPriceRange.end}",
                    style: const TextStyle(
                      color: secondaryTextColor,
                      fontSize: fontSize16,
                      fontWeight: fontWeightMedium,
                      height: 1.4,
                    ),
                  ),
                ],
              );
            },
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return RangeSlider(
                activeColor: primaryColor,
                inactiveColor: Colors.grey.withAlpha(23),
                values: productProvider.tempPriceRange,
                min: 0,
                max: 2000,
                divisions: 200,
                labels: RangeLabels(
                  productProvider.tempPriceRange.start.round().toString(),
                  productProvider.tempPriceRange.end.round().toString(),
                ),
                onChanged: (value) {
                  productProvider.updatePriceRange(value);
                },
              );
            },
          ),
          Text(
            Localization.of().ratingText,
            style: const TextStyle(
              fontSize: fontSize18,
              color: primaryColor,
              fontWeight: fontWeightBold,
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return RadioGroup<double>(
                  groupValue: productProvider.tempRating,
                  onChanged: (value) {
                    productProvider.selectRating(value);
                  },
                  child: Column(
                    children: [
                      RadioListTile<double>(
                        toggleable: true,
                        radioSide: const BorderSide(style: BorderStyle.solid),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        value: 3.0,
                        activeColor: primaryColor,
                        title: Row(
                          children: [
                            const Text("3.0"),
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text(Localization.of().aboveText)
                          ],
                        ),
                      ),
                      RadioListTile<double>(
                        radioSide: const BorderSide(style: BorderStyle.solid),
                        toggleable: true,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        value: 4.0,
                        activeColor: primaryColor,
                        title: Row(
                          children: [
                            const Text("4.0"),
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text(Localization.of().aboveText),
                          ],
                        ),
                      ),
                      RadioListTile<double>(
                        radioSide: const BorderSide(style: BorderStyle.solid),
                        toggleable: true,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        value: 5.0,
                        activeColor: primaryColor,
                        title: Row(
                          children: [
                            const Text("5.0"),
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text(Localization.of().aboveText),
                          ],
                        ),
                      )
                    ],
                  ));
            },
          ),
          const SizedBox(height: 10),
          Text(
            Localization.of().discountText,
            style: const TextStyle(
              fontSize: fontSize18,
              color: primaryColor,
              fontWeight: fontWeightBold,
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return Column(
                children: [
                  CheckboxListTile(
                    value: productProvider.tempDiscounts.contains(10),
                    onChanged: (value) {
                      productProvider.toggleDiscount(10);
                    },
                    activeColor: primaryColor,
                    title: Row(children: [
                      const Text("10%"),
                      Text(Localization.of().moreText),
                    ]),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: productProvider.tempDiscounts.contains(20),
                    onChanged: (value) {
                      productProvider.toggleDiscount(20);
                    },
                    activeColor: primaryColor,
                    title: Row(children: [
                      const Text("20%"),
                      Text(Localization.of().moreText),
                    ]),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    value: productProvider.tempDiscounts.contains(40),
                    onChanged: (value) {
                      productProvider.toggleDiscount(40);
                    },
                    activeColor: primaryColor,
                    title: Row(children: [
                      const Text("40%"),
                      Text(Localization.of().moreText),
                    ]),
                    controlAffinity: ListTileControlAffinity.leading,
                  )
                ],
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          PrimaryButton(
            backgroundColor: primaryColor,
            buttonText: Localization.of().applyFilterText,
            textColor: secondaryColor,
            buttonColor: primaryColor,
            onButtonClick: () {
              context.read<ProductProvider>().applyFilters();
              locator<NavigationUtils>().pop();
            },
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
                onPressed: () {
                  context.read<ProductProvider>().clearFilters();
                  locator<NavigationUtils>().pop();
                },
                child: Text(
                  Localization.of().clearFilterText,
                )),
          )
        ],
      ),
    );
  }
}
