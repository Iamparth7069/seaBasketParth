import 'package:seabasket/src/base/utils/constants/preference_key_constant.dart';
import 'package:seabasket/src/base/utils/preference_utils.dart';

class CheckoutApiManager {
  Future<bool> placeOrderApiCall() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Future<bool> saveCardApiCall(
      String cardNumber, String expiryDate, String securityCode) async {
    await Future.delayed(const Duration(milliseconds: 200));
    setString(prefkeyCardNumber, cardNumber);
    setString(prefkeyExpiryDate, expiryDate);
    setString(prefkeySecurityCode, securityCode);
    return true;
  }

  Future<Map<String, String>> getSavedCardApiCall() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'cardNumber': getString(prefkeyCardNumber),
      'expiryDate': getString(prefkeyExpiryDate),
      'securityCode': getString(prefkeySecurityCode),
    };
  }

  Future<void> clearCardApiCall() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setString(prefkeyCardNumber, "");
    setString(prefkeyExpiryDate, "");
    setString(prefkeySecurityCode, "");
  }
}
