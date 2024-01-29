import 'package:flutter/material.dart';

enum ToastPosition {
  top,
  center,
  bottom,
}

class Toast {
  static OverlayEntry? _overlayEntry;
  static bool _showing = false;
  static DateTime? _startedTime;
  static String? _msg;
  static int? _showTime;
  static Color? _bgColor;
  static Color? _textColor;
  static double? _textSize;
  static ToastPosition? _toastPosition;
  static double? _pdHorizontal;
  static double? _pdVertical;
  static void toast(
      BuildContext context, {
        String? msg,
        int showTime = 2000,
        Color bgColor = Colors.black,
        Color textColor = Colors.white,
        double textSize = 14.0,
        ToastPosition position = ToastPosition.center,
        double pdHorizontal = 20.0,
        double pdVertical = 10.0,
      }) async {
    assert(msg != null);
    _msg = msg;
    _startedTime = DateTime.now();
    _showTime = showTime;
    _bgColor = bgColor;
    _textColor = textColor;
    _textSize = textSize;
    _toastPosition = position;
    _pdHorizontal = pdHorizontal;
    _pdVertical = pdVertical;
    OverlayState overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
            top: buildToastPosition(context),
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: AnimatedOpacity(
                    opacity: _showing ? 1.0 : 0.0,
                    duration: _showing
                        ? Duration(milliseconds: 100)
                        : Duration(milliseconds: 400),
                    child: _buildToastWidget(),
                  ),
                )),
          ));
      overlayState.insert(_overlayEntry!);
    } else {
      _overlayEntry?.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: _showTime!));
    if (DateTime.now().difference(_startedTime!).inMilliseconds >= _showTime!) {
      _showing = false;
      _overlayEntry?.markNeedsBuild();
      await Future.delayed(Duration(milliseconds: 400));
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static _buildToastWidget() {
    return Center(
      child: Card(
        color: _bgColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _pdHorizontal!, vertical: _pdVertical!),
          child: Text(
            _msg??'',
            style: TextStyle(
              fontSize: _textSize,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }

  static buildToastPosition(context) {
    var backResult;
    if (_toastPosition == ToastPosition.top) {
      backResult = MediaQuery.of(context).size.height * 1 / 4;
    } else if (_toastPosition == ToastPosition.center) {
      backResult = MediaQuery.of(context).size.height * 2 / 5;
    } else {
      backResult = MediaQuery.of(context).size.height * 3 / 4;
    }
    return backResult;
  }
}