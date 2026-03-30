import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/providers/bottom_nav_provider.dart';
import 'package:seabasket/src/providers/order_status_provider.dart';
import 'package:seabasket/src/widgets/primary_button.dart';

class OrderStatusScreen extends StatefulWidget {
  final String? orderId;
  final String? status;

  const OrderStatusScreen({super.key, this.orderId, this.status});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.status != null) {
        context.read<OrderStatusProvider>().setStatusFromString(widget.status!);
      } else if (widget.orderId != null) {
        context.read<OrderStatusProvider>().loadOrderStatus(widget.orderId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderStatusProvider>(
      builder: (context, orderStatusProvider, child) {
        if (orderStatusProvider.isLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              locator<NavigationUtils>().pop();
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.getWidth(0.05),
              vertical: context.getHeight(0.02),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Localization.of().orderStatusText,
                  style: const TextStyle(
                    fontSize: fontSize20,
                    fontWeight: fontWeightBold,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: context.getHeight(0.02)),
                ...OrderStatus.values.map((status) {
                  final isCompleted =
                      status.index <= orderStatusProvider.currentStatus.index;
                  final isLast = status == OrderStatus.delivered;
                  return _buildStep(
                    title: status.displayTitle,
                    subtitle: status.displaySubtitle,
                    isCompleted: isCompleted,
                    isLast: isLast,
                  );
                }),
                if (orderStatusProvider.isDelivered) ...[
                  SizedBox(height: context.getHeight(0.03)),
                  const Divider(
                    height: 25,
                  ),
                  _buildRatingSection(orderStatusProvider),
                ],
              ],
            ),
          ).commonScaffold(
            context: context,
            title: Localization.of().trackOrderTitle,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                locator<NavigationUtils>().pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: secondaryColor,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: context.getHeight(0.07),
                color: isCompleted ? primaryColor : Colors.grey.shade300,
              ),
          ],
        ),
        SizedBox(width: context.getWidth(0.04)),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize16,
                  fontWeight: isCompleted ? fontWeightBold : fontWeightRegular,
                  color: isCompleted ? primaryTextColor : secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: context.getWidth(0.7),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: fontSize12,
                    color:
                        isCompleted ? secondaryTextColor : Colors.grey.shade400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(OrderStatusProvider orderStatusProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Localization.of().leaveReviewText,
          style: const TextStyle(
            fontSize: fontSize20,
            fontWeight: fontWeightBold,
            color: primaryTextColor,
          ),
        ),
        SizedBox(height: context.getHeight(0.01)),
        Text(
          Localization.of().orderMessageText,
          style: const TextStyle(
            fontSize: fontSize16,
            fontWeight: fontWeightSemiBold,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Localization.of().giveRatingMessage,
          style: const TextStyle(
            fontSize: fontSize14,
            color: secondaryTextColor,
          ),
        ),
        SizedBox(height: context.getHeight(0.02)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                orderStatusProvider.selectedRating;
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  index < orderStatusProvider.selectedRating
                      ? Icons.star
                      : Icons.star_border,
                  color: index < orderStatusProvider.selectedRating
                      ? Colors.orange
                      : Colors.grey.shade400,
                  size: 40,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: context.getHeight(0.02)),
        PrimaryButton(
          buttonText: Localization.of().submitText,
          buttonColor: primaryButtonColor,
          backgroundColor: primaryButtonColor,
          onButtonClick: () => _handleSubmitReview(orderStatusProvider),
        ),
        SizedBox(height: context.getHeight(0.02)),
        TextButton(
            onPressed: _handleHomeScreen,
            child: Center(
              child: Text(
                Localization.of().gotoHomeText,
                style: const TextStyle(
                  fontSize: fontSize14,
                  color: primaryTextColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            )),
      ],
    );
  }

  void _handleSubmitReview(OrderStatusProvider orderStatusProvider) async {
    if (orderStatusProvider.selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localization.of().selectRatingMessage),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }
    final success = await orderStatusProvider.submitReview();
    if (success && mounted) {
      _handleHomeScreen();
    }
  }

  void _handleHomeScreen() {
    context.read<OrderStatusProvider>().reset();
    context.read<BottomNavProvider>().changeTab(0);
    locator<NavigationUtils>().pushAndRemoveUntil(routeBase);
  }



}
