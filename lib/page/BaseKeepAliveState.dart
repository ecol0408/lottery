import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottery/IConstant.dart';
import 'package:lottery/listener/DataChangeListener.dart';
import 'package:lottery/utils/ViewUtils.dart';
import 'dart:html' as html;

abstract class BaseKeepAliveState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver
    implements DataChangeListener {
  var expandeSpace = const Expanded(
    child: SizedBox(),
  );
  var isDispose = false;
  bool isLoading = false;
  bool isErr = false;
  String errMsg = '';
  int page = 1;
  var statusBarHeight, appBarHeight, windowWidth, windowHeight;
  AudioPlayer audioPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
  ScrollController scrollController = ScrollController();
  bool isFull = false;
  List datas = [];

  void nextPage(Widget widget, {bool isFinish = false}) {
    if (isFinish) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => widget),
        (route) => route == null,
      );
    } else {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
    }
  }

  Widget buildBack({Function? callBack}) {
    return InkWell(
      borderRadius: BorderRadius.circular(appBarHeight),
      child: Container(
        width: appBarHeight,
        height: appBarHeight,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/icons/ic_back.png',
          width: 10.33,
          height: 19.67,
          color: Colors.white,
        ),
      ),
      onTap: () {
        callBack == null ? finish() : callBack.call();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    IConstant.OPEN_PAGES.add(this);
    DataChangeListener.attachDataChangeListener(this);
    isFull = html.document.fullscreenElement != null;
    html.window.onResize.listen((html.Event event) {
      isFull = html.document.fullscreenElement != null;
    });
  }

  @override
  void dispose() {
    IConstant.OPEN_PAGES.remove(this);
    DataChangeListener.dettachDataChangeListener(this);
    isDispose = true;
    audioPlayer.stop();
    audioPlayer.release();
    super.dispose();
  }

  @override
  void onDataChange() {}

  finish() {
    finishContext(context);
  }

  @override
  void setState(fn) {
    if (isDispose) return;
    super.setState(fn);
  }

  void finishContext(BuildContext? context) {
    try {
      if (context == null) return;
      Navigator.pop(context);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    appBarHeight = ViewUtils.getAppBarHeight();
    statusBarHeight = ViewUtils.getStatusBarHeight(context);
    windowWidth = ViewUtils.getWindowWidth(context);
    windowHeight = ViewUtils.getWindowHeight(context);
    return super.build(context);
  }

  @override
  bool get wantKeepAlive => false;
}
