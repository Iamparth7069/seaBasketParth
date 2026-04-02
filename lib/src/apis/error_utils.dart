import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:seabasket/src/base/utils/dialog_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/progress_dialog_utils.dart';

Future<void> handleHttpError(DioException e) async {
  ProgressDialogUtils.dismissProgressDialog();

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      showAlertDialog(message: Localization.of().poorInternetConnection);
      break;
    case DioExceptionType.badResponse:
      if (e.response?.statusCode == 401) {
        showAlertDialog(message: _getErrorMessage(e.response?.data));
      } else {
        showAlertDialog(message: _getErrorMessage(e.response?.data));
      }
      break;
    default:
      showAlertDialog(message: e.error.toString());
  }
}

String _getErrorMessage(dynamic data) {
  if (data == null) return "";
  if (data is String) return data;

  if (data is Map) {
    final detail = data["detail"];

    if (detail == null) return "";
    if (detail is String) return detail;
    if (detail is Map) {
      return detail["message"]?.toString() ??
          detail["error"]?.toString() ??
          "Error";
    }
  }
  return data.toString();
}

Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi)) {
    return true;
  }
  showAlertDialog(message: Localization.of().internetNotConnected);
  return false;
}
