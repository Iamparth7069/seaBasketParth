import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/extensions/string_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:seabasket/src/providers/user_provider.dart';
import 'package:seabasket/src/widgets/primary_button.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await locator<AuthController>().updateProfile(context);
      final user = context.read<UserProvider>().currentUser;
      if (user != null) {
        _fullNameController.text = user.username ?? "";
        _emailController.text = user.email;
        _phoneController.text = user.phoneNumber ?? "";
        _addressController.text = user.address ?? "";
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (!userProvider.isLoggedIn) {
          return _notLoggedIn();
        }
        return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.getWidth(0.05),
                    vertical: context.getHeight(0.02)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            PrimaryTextField(
                              label: Localization.of().fullNameText,
                              hint: "",
                              controller: _fullNameController,
                              readOnly: true,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: context.getHeight(0.02)),
                            PrimaryTextField(
                              label: Localization.of().emailLabel,
                              hint: "",
                              controller: _emailController,
                              readOnly: true,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: context.getHeight(0.02)),
                            PrimaryTextField(
                              label: Localization.of().phoneNumberText,
                              hint: "",
                              contentPadding: const EdgeInsets.only(left: 4),
                              controller: _phoneController,
                              type: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validateFunction: (value) =>
                                  value?.isValidPhoneNumber(),
                            ),
                            SizedBox(height: context.getHeight(0.02)),
                            PrimaryTextField(
                              contentPadding:
                                  const EdgeInsets.only(top: 14, left: 4),
                              label: Localization.of().addressText,
                              hint: Localization.of().addressHint,
                              controller: _addressController,
                              textInputAction: TextInputAction.done,
                              maxLines: 3,
                              validateFunction: (value) => value?.isFieldEmpty(
                                  Localization.of().msgAddressEmpty),
                            ),
                            SizedBox(height: context.getHeight(0.03)),
                            PrimaryButton(
                                buttonText: Localization.of().submitText,
                                buttonColor: primaryButtonColor,
                                backgroundColor: primaryButtonColor,
                                onButtonClick: () {
                                  _handleSubmit();
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .commonScaffold(
                context: context,
                title: Localization.of().myDetailsText,
                centerTitle: true,
                leading: IconButton(
                    onPressed: locator<NavigationUtils>().pop,
                    icon: const Icon(Icons.arrow_back)));
      },
    );
  }

  Widget _notLoggedIn() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.getHeight(0.02),
            vertical: context.getHeight(0.07)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: profileContainerColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 48,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              Localization.of().notLoggedIn,
              style: const TextStyle(
                fontSize: fontSize18,
                fontWeight: fontWeightSemiBold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Localization.of().loginMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  locator<NavigationUtils>().push(routeLogin);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  Localization.of().loginText,
                  style: const TextStyle(
                    fontSize: fontSize16,
                    fontWeight: fontWeightSemiBold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = await locator<AuthController>().updateProfile(
      context,
      phone: _phoneController.text,
      address: _addressController.text,
    );

    if (updatedUser != null && mounted) {
      context.read<UserProvider>().setUser(updatedUser);

      _phoneController.text = updatedUser.phoneNumber ?? "";
      _addressController.text = updatedUser.address ?? "";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Localization.of().profileUpdateMessage)),
      );
    }
  }
}
