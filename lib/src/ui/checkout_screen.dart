// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:seabasket/src/base/dependencyinjection/locator.dart';
// import 'package:seabasket/src/base/extensions/context_extension.dart';
// import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
// import 'package:seabasket/src/base/extensions/string_extension.dart';
// import 'package:seabasket/src/base/utils/constants/color_constant.dart';
// import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
// import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
// import 'package:seabasket/src/base/utils/localization/localization.dart';
// import 'package:seabasket/src/base/utils/navigation_utils.dart';
// import 'package:seabasket/src/controllers/auth/auth_controller.dart';
// import 'package:seabasket/src/providers/cart_provider.dart';
// import 'package:seabasket/src/providers/checkout_provider.dart';
// import 'package:seabasket/src/providers/user_provider.dart';
// import 'package:seabasket/src/widgets/primary_button.dart';
// import 'package:seabasket/src/widgets/primary_text_field.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _addressController;

//   @override
//   void initState() {
//     super.initState();
//     _addressController = TextEditingController();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final user = context.read<UserProvider>().currentUser;
//       // final savedAddress = user?.address ?? "";
//       // _addressController.text = savedAddress;
//       // if (savedAddress.isEmpty) {
//       //   context.read<CheckoutProvider>().setEditing(true);
//       // }
//     });
//   }

//   @override
//   void dispose() {
//     _addressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<CartProvider, CheckoutProvider>(
//       builder: (context, cartProvider, checkoutProvider, child) {
//         return SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             horizontal: context.getWidth(0.05),
//             vertical: context.getHeight(0.02),
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   Localization.of().deliveryAddressText,
//                   style: const TextStyle(
//                     fontSize: fontSize18,
//                     fontWeight: fontWeightBold,
//                     color: primaryTextColor,
//                   ),
//                 ),
//                 SizedBox(height: context.getHeight(0.02)),
//                 _addressSection(checkoutProvider),
//                 SizedBox(height: context.getHeight(0.03)),
//                 const Divider(),
//                 SizedBox(height: context.getHeight(0.02)),
//                 Text(
//                   Localization.of().orderSummaryText,
//                   style: const TextStyle(
//                     fontSize: fontSize18,
//                     fontWeight: fontWeightBold,
//                     color: primaryTextColor,
//                   ),
//                 ),
//                 SizedBox(height: context.getHeight(0.02)),
//                 _orderSummary(cartProvider),
//                 SizedBox(height: context.getHeight(0.03)),
//                 checkoutProvider.isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : PrimaryButton(
//                         buttonText: Localization.of().contiunePaymentText,
//                         buttonColor: primaryButtonColor,
//                         backgroundColor: primaryButtonColor,
//                         trailingIcon: Icons.arrow_forward,
//                         onButtonClick: _handleContinue,
//                       ),
//                 SizedBox(height: context.getHeight(0.02)),
//               ],
//             ),
//           ),
//         ).commonScaffold(
//           context: context,
//           title: Localization.of().checkoutText,
//           centerTitle: true,
//           leading: IconButton(
//             onPressed: locator<NavigationUtils>().pop,
//             icon: const Icon(Icons.arrow_back),
//           ),
//         );
//       },
//     );
//   }

//   Widget _addressSection(CheckoutProvider checkoutProvider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         PrimaryTextField(
//           label: "",
//           hint: Localization.of().addressHint,
//           controller: _addressController,
//           maxLines: 3,
//           readOnly: !checkoutProvider.isEditing,
//           contentPadding: const EdgeInsets.all(14),
//           textInputAction: TextInputAction.done,
//           validateFunction: (value) =>
//               value?.isFieldEmpty(Localization.of().msgAddressEmpty),
//         ),
//         SizedBox(height: context.getHeight(0.01)),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: () {
//               checkoutProvider.toggleEditing();
//             },
//             child: Text(
//               checkoutProvider.isEditing
//                   ? Localization.of().save
//                   : Localization.of().changeText,
//               style: const TextStyle(
//                 color: primaryButtonColor,
//                 fontWeight: fontWeightMedium,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _orderSummary(CartProvider cartProvider) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: containerBorderColor),
//       ),
//       child: Column(
//         children: [
//           _summaryRow(
//             Localization.of().subTotalText,
//             "₹ ${cartProvider.subtotal}",
//           ),
//           SizedBox(height: context.getHeight(0.01)),
//           _summaryRow(
//             Localization.of().shippingFeeText,
//             "₹ ${cartProvider.shippingFee}",
//           ),
//           const Divider(height: 24),
//           _summaryRow(
//             Localization.of().totalText,
//             "₹ ${cartProvider.total}",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summaryRow(
//     String label,
//     String value,
//   ) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: fontSize14,
//             color: primaryTextColor,
//             fontWeight: fontWeightRegular,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//               fontSize: fontSize16,
//               color: primaryTextColor,
//               fontWeight: fontWeightBold),
//         ),
//       ],
//     );
//   }

//   void _handleContinue() async {
//     if (!_formKey.currentState!.validate()) return;
//     FocusScope.of(context).unfocus();

//     await context.read<AuthController>().updateProfile(
//           context,
//           context.read<UserProvider>().currentUser?.phoneNumber ?? "",
//           _addressController.text,
//         );

//     locator<NavigationUtils>().pushReplacement(routePayment);
//   }
// }
