import 'localization.dart';

class LocalizationEN implements Localization {
  @override
  String get appName => "seabasket";

  @override
  String get ok => "OK";

  @override
  String get cancel => "Cancel";

  @override
  String get alertPermissionNotRestricted =>
      "Please grant permission from settings to access this feature";

  @override
  String get internetNotConnected =>
      "No internet connection. Please check your internet connection";

  @override
  String get poorInternetConnection =>
      "Poor internet connection. Please check your internet connection";

  @override
  String get delete => "Delete";

  @override
  String get edit => "Edit";

  @override
  String get done => "Done";

  @override
  String get cameraTitle => "Camera";

  @override
  String get galleryTitle => "Gallery";

  @override
  String get no => "No";

  @override
  String get yes => "Yes";

  @override
  String get logout => "Logout";

  @override
  String get save => "Save";

  @override
  String get search => "Search";

  // Auth Strings
  @override
  String get msgInvalidRegister =>
      "user already register with this email address";

  @override
  String get loginText => "Login";
  @override
  String get createAccountText => "Create an Account";

  @override
  String get joinAccount => "Join";
  @override
  String get msgNotAccount => "Don't have an account?";

  @override
  String get msgAlreadyAccount => "Already have an account?";
  @override
  String get resetPassword => "Reset your password";

  @override
  String get forgotPassword => "Forgot your password?";

  @override
  String get msgInvalidLogin => "Invalid email or password";

  @override
  String get userNameHint => "Enter your full name";

  @override
  String get userNameLabel => "Full Name";

  @override
  String get emailHint => "Enter your email address";

  @override
  String get passwordHint => "Enter your password";

  @override
  String get emailLabel => "Email";

  @override
  String get passwordLabel => "Password";

  @override
  String get confirmPasswordLabel => "Confirm Password";

  @override
  String get msgEmailEmpty => "Email required";

  @override
  String get msgEmailInvalid => "Please enter valid email address";

  @override
  String get msgPasswordEmpty => "Password is empty";

  @override
  String get msgPasswordNotMatch => "Password doesn't match";

  @override
  String get msgPasswordError =>
      "Password should be at least 8 characters long and have atleast one uppercase, one alphanumeric and one number.";

  @override
  String get loginSubtitle => "It's great to see you again.";

  @override
  String get loginTitle => "Login to your account";

  @override
  String get registerTitle => "Create an account";

  @override
  String get registerSubtitle => "Let's create your account";

  @override
  String get registerMessage => "By signing up you agree to our";

  @override
  String get registerTermMessage => "Terms, Privacy Policy,";

  @override
  String get cookieUse => "Cookie Use";

  @override
  String get and => "and";

  @override
  String get forgotPasswordTitle => "Forgot Password";

  @override
  String get forgotPasswordSubTitle =>
      "Enter your email for the verification process. We will send 4 digits code to your email.";

  @override
  String get sendCode => "Send code";

  @override
  String get notRegistered => "No user registered with this email";

  @override
  String get otpScreenTitle => "Enter 4 Digit Code";

  @override
  String get otpSubTitle1 =>
      "Enter 4 digit code that you receive on your email (";

  @override
  String get otpSubTitle2 => ")";

  @override
  String get continueText => "Continue";

  @override
  String get emailNotReceived => "Email not received?";

  @override
  String get resendCode => "Resend code";

  @override
  String get tryLater => "Please try again later!";

  @override
  String get resetPasswordTitle => "Reset Password";

  @override
  String get resetPasswordSubTitle =>
      "Set the new password for your account so you can login and access all the features.";

  @override
  String get passwordChangedText => "Password changed!";

  @override
  String get passwordChangedSubText =>
      "You can now use your new password to login to your account.";

  @override
  String get invalidOtp => "Invalid OTP";

  @override
  String get otpMessage => "Your 4 digit OTP:";

  @override
  String get newOtpText => "New OTP:";

  @override
  String get skipText => "Skip";
  //Base screen string
  @override
  String get homeText => "Home";

  @override
  String get accountText => "Account";

  @override
  String get savedText => "Saved";

  //Home screen String
  @override
  String get discoverText => "Discover";

  @override
  String get noProductMessage => "No Product available";

  @override
  String get noProductFoundText => "No matching Product found";

  //filter Bottom sheet
  @override
  String get filterText => "Filters";

  @override
  String get sortByText => "Sort By";

  @override
  String get priceText => "Price";

  @override
  String get applyFilterText => "Apply Filters";

  @override
  String get ratingText => "Ratings";

  @override
  String get aboveText => "& above";

  @override
  String get discountText => "Discount";

  @override
  String get moreText => " or more";

  @override
  String get clearFilterText => "Clear Filters";

  // search screen text

  @override
  String get noResultFoundText => "No results found!";

  @override
  String get noResultFoundSubText =>
      "  Try a similar word or something more general.";

  // product detail screen text
  @override
  String get detailsText => "Details";

  @override
  String get chooseSizeText => "Choose Size";

  @override
  String get addToCartText => "Add to Cart";
  @override
  String get addedCartText => "added to cart";

  @override
  String get buyNowText => "Buy Now";
  @override
  String get goToCartText => "Go to Cart";

  @override
  String get loginAlertMessage => "Please login First!";

  //Account screen
  @override
  String get myOrdersText => "My orders";

  //profile screen
  @override
  String get fullNameText => "Full Name";

  @override
  String get msgPhoneNumberEmpty => "Phone number required";

  @override
  String get phoneNumberText => "Phone Number";
  @override
  String get phoneNumberHint => "Enter Phone number";
  @override
  String get addressText => "Address";
  @override
  String get addressHint => "Enter Address";

  @override
  String get msgAddressEmpty => "Address is required";

  @override
  String get submitText => "Submit";

  @override
  String get phoneNumberInvalid => "Invalid Phone Number!";

  @override
  String get msgLogoutConfirm => "Are you sure  you want to log out?";

  @override
  String get notLoggedIn => "You're not logged in";

  @override
  String get myDetailsText => "My Details";

  @override
  String get loginMessage => "Please login first.";

  @override
  String get profileUpdateMessage => "Profile updated successfully!";
  // cart screen
  @override
  String get cartEmptyText => "Your Cart is Empty!";

  @override
  String get cartEmptySubText => "When you add products,they'll \n appear here";

  @override
  String get totalText => "Total";

  @override
  String get subTotalText => "Sub-total";
  @override
  String get shippingFeeText => "Shipping fees";

  @override
  String get goToCheckoutText => "Go To Checkout";

  @override
  String get searchHintText => "Search for clothes...";

  @override
  String get searchText => "Search";

  @override
  String get cartText => "Cart";

  @override
  String get savedItemText => "Saved Items";

  @override
  String get yourDetailsText => "Your details";

  @override
  String get myCartText => "My Cart";

  @override
  String get msgUpdateProfileFailed => "Profile not updated!";

  // checkout
  @override
  String get deliveryAddressText => "Delivery Address";

  @override
  String get changeText => "Change";

  @override
  String get orderSummaryText => "Order Summary";

  @override
  String get placeOrderText => "Place Order";

  @override
  String get checkoutText => "Checkout";

  @override
  String get contiunePaymentText => "Continue to payment";

  //payment

  @override
  String get cardDetailsText => "Card Details";

  @override
  String get addCardTitle => "Add Debit or Credit Card";

  @override
  String get cardNumberLabel => "Card Number";

  @override
  String get expiryDateLabel => "Expiry Date";

  @override
  String get expiryDateHint => "MM/YY";
  @override
  String get securityCodeLabel => "Security Code";

  @override
  String get securityCodeHint => "CVV";

  @override
  String get orderPlacedText => "Congratulations!";

  @override
  String get orderPlacedSubText => "  Your order has been placed.!";

  @override
  String get trackOrderText => "Track Your Order";

  @override
  String get validCardMessage => "Please enter card number";
  @override
  String get validSecurityCodeMessage => "Please enter security code";

  @override
  String get expiryDateEmptyMessage => "Please enter expiry date";
  @override
  String get invalidExpiryDateMessage => "Enter valid expiry date (MM/YY)";
  @override
  String get invalidMonthMessage => "Enter valid month";

  @override
  String get invalidDateMessage => "Enter valid Date";

  //order detail

  @override
  String get emptyOrderMessage => "No Orders Yet";

  @override
  String get emptyOrderSubMessage => "Your placed orders will appear here";

  @override
  String get sizeText => "Size:";

  @override
  String get quantityText => "Qty";
  @override
  String get shippingText => "Shipping:";

  @override
  String get orderTotalText => "Order Total";

  @override
  String get orderDetailText => "My Orders";
  @override
  String get orderStatusText => "Order Status";
  @override
  String get trackOrderTitle => "Track Order";

  @override
  String get leaveReviewText => "Leave a Review";

  @override
  String get orderMessageText => "How was your order?";

  @override
  String get giveRatingMessage =>
      "Please give your rating and also your review.";
  @override
  String get gotoHomeText => "Go to Home";

  @override
  String get selectRatingMessage => "Please Select rating";

  @override
  String get paymentSuccessText => "Payment Successful!";

  @override
  String get unavailableItemMessage => "This item is currently unavailable.";

  @override
  String get paymentFailedText => "Payment Failed!";

  @override
  String get orderIdText => "Order ID:";

  @override
  String get inProgressText => "In Progress";

  @override
  String get selectSizeFirstMessage => "Please select a size first.";

  @override
  String get itemCountText => "Items";

  @override
  String get ratingSubmittedMessage => "Rating submitted successfully!";

  @override
  String get ratingFailedMessage =>
      "Failed to submit rating. Please try again.";

  @override
  String get orderHistoryTitle => "Order History";

  @override
  String get giveRatingText => "Your Rating for this purchase";

  @override
  String get serverFailError => "Server failed to return payment intent";
}
