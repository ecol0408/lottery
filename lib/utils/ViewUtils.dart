import 'package:flutter/material.dart';

class ViewUtils {

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getAppBarHeight() {
    return AppBar().preferredSize.height;
  }

  static double getWindowHeight(BuildContext context) {
    MediaQueryData mediaQuery = MediaQueryData.fromView(View.of(context));
    return mediaQuery.size.height;
  }

  static double getWindowWidth(BuildContext context) {
    MediaQueryData mediaQuery = MediaQueryData.fromView(View.of(context));
    return mediaQuery.size.width;
  }

  static buildTextEditingController(String str) {
    return TextEditingController.fromValue(
        TextEditingValue(text: str, selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: str.length))));
  }


  static void showPopDialog(BuildContext context, Widget widget, bool barrierDismissible, {Function(BuildContext context)? callBack}) {
    showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          if (callBack != null) callBack(context);
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: widget,
          );
        });
  }
}
