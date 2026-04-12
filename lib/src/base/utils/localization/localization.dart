import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:intl/intl.dart';
import 'package:seabasket/src/ui/order_history.dart';

import 'localization_en.dart';

class MyLocalizationsDelegate extends LocalizationsDelegate<Localization> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'en',
      ].contains(locale.languageCode);

// @override
////   bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) => _load(locale);

  static Future<Localization> _load(Locale locale) async {
    final String name =
        (locale.countryCode == null || locale.countryCode!.isEmpty)
            ? locale.languageCode
            : locale as String;

    final localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale = localeName;

    // if( locale.languageCode == "fr" ) {
    //   return LocalizationFR();
    // } else {
    //   return LocalizationEN();
    // }

    return LocalizationEN();
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}

abstract class Localization {
  static Localization of() {
    return Localizations.of<Localization>(
        locator<NavigationUtils>().getCurrentContext, Localization)!;
  }

  // Common Strings
  String get internetNotConnected;
  String get poorInternetConnection;
  String get alertPermissionNotRestricted;
  String get appName;
  String get ok;
  String get cancel;
  String get edit;
  String get delete;
  String get done;
  String get logout;
  String get galleryTitle;
  String get cameraTitle;
  String get yes;
  String get no;
  String get save;
  String get search;

  // Auth Stringd
  String get loginTitle;
  String get loginSubtitle;
  String get registerTitle;
  String get registerSubtitle;
  String get userNameLabel;
  String get userNameHint;
  String get emailLabel;
  String get emailHint;
  String get passwordLabel;
  String get confirmPasswordLabel;
  String get passwordHint;
  String get msgEmailEmpty;
  String get msgEmailInvalid;
  String get msgPasswordEmpty;
  String get msgPasswordError;
  String get msgPasswordNotMatch;
  String get msgInvalidLogin;
  String get forgotPassword;
  String get resetPassword;
  String get msgNotAccount;
  String get joinAccount;
  String get loginText;
  String get registerMessage;
  String get registerTermMessage;
  String get cookieUse;
  String get and;
  String get msgAlreadyAccount;
  String get createAccountText;
  String get msgInvalidRegister;
  String get forgotPasswordTitle;
  String get forgotPasswordSubTitle;
  String get sendCode;
  String get notRegistered;
  String get otpScreenTitle;
  String get otpSubTitle1;
  String get otpSubTitle2;
  String get continueText;
  String get emailNotReceived;
  String get resendCode;
  String get tryLater;
  String get resetPasswordTitle;
  String get resetPasswordSubTitle;
  String get passwordChangedText;
  String get passwordChangedSubText;
  String get invalidOtp;
  String get otpMessage;
  String get newOtpText;
  String get skipText;

  // base screen
  String get homeText;
  String get accountText;
  String get savedText;
  String get noProductMessage;

//Home screen

  String get discoverText;
  String get searchHintText;
  String get searchText;
  String get noProductFoundText;

// Filter Bottom sheet
  String get filterText;
  String get sortByText;
  String get priceText;
  String get applyFilterText;
  String get ratingText;
  String get aboveText;
  String get discountText;
  String get moreText;
  String get clearFilterText;

// Search Screen
  String get noResultFoundText;
  String get noResultFoundSubText;

//product detail screen
  String get detailsText;
  String get chooseSizeText;
  String get addToCartText;
  String get buyNowText;
  String get addedCartText;
  String get goToCartText;
  String get loginAlertMessage;

//account screen
  String get myOrdersText;

// profile screen
  String get fullNameText;
  String get msgPhoneNumberEmpty;
  String get phoneNumberText;
  String get phoneNumberHint;
  String get phoneNumberInvalid;
  String get addressText;
  String get addressHint;
  String get msgAddressEmpty;
  String get submitText;
  String get msgLogoutConfirm;
  String get notLoggedIn;
  String get myDetailsText;
  String get loginMessage;
  String get profileUpdateMessage;

  //cart Screen
  String get cartEmptyText;
  String get cartEmptySubText;
  String get totalText;
  String get subTotalText;
  String get shippingFeeText;
  String get goToCheckoutText;
  String get cartText;
  String get savedItemText;
  String get yourDetailsText;
  String get msgUpdateProfileFailed;

  // cart
  String get myCartText;
  String get selectSizeFirstMessage;

  //checkout screen
  String get deliveryAddressText;
  String get changeText;
  String get orderSummaryText;
  String get placeOrderText;
  String get checkoutText;
  String get paymentSuccessText;
  String get contiunePaymentText;
  String get unavailableItemMessage;

  //payment
  String get cardDetailsText;
  String get orderPlacedText;
  String get orderPlacedSubText;
  String get trackOrderText;
  String get addCardTitle;
  String get cardNumberLabel;
  String get validCardMessage;
  String get expiryDateLabel;
  String get expiryDateHint;
  String get securityCodeLabel;
  String get securityCodeHint;
  String get validSecurityCodeMessage;
  String get expiryDateEmptyMessage;
  String get invalidExpiryDateMessage;
  String get invalidMonthMessage;
  String get invalidDateMessage;
  String get paymentFailedText;

  // order detail screen and Order history
  String get orderDetailText;
  String get emptyOrderMessage;
  String get emptyOrderSubMessage;
  String get sizeText;
  String get quantityText;
  String get shippingText;
  String get orderTotalText;
  String get orderIdText;
  String get inProgressText;
  String get itemCountText;

  // order status screen
  String get trackOrderTitle;
  String get orderStatusText;
  String get leaveReviewText;
  String get orderMessageText;
  String get giveRatingMessage;
  String get gotoHomeText;
  String get selectRatingMessage;
  String get ratingSubmittedMessage;
  String get ratingFailedMessage;
  String get orderHistoryTitle;
  String get giveRatingText;

  // strip payment
  String get serverFailError;
}
