import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/IConstant.dart';
import 'package:lottery/listener/DataChangeListener.dart';
import 'package:lottery/page/BaseKeepAliveState.dart';
import 'package:lottery/page/PeoplePage.dart';
import 'package:lottery/page/ResultPage.dart';
import 'package:lottery/utils/AppUtils.dart';
import 'package:lottery/utils/TextUtils.dart';
import 'package:lottery/utils/ViewUtils.dart';
import 'package:lottery/widget/PartRefreshWidget.dart';
import 'package:lottery/widget/Toast.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends BaseKeepAliveState<MainPage> {
  GlobalKey<PartRefreshWidgetState> content_key = GlobalKey();
  int step = 0; //0初始化等待开始，1正在随机
  int result = -1;

  updatePeople() async {
    String people = await AppUtils.getConfig(IConstant.PEOPLE_LIST, "[]");
    if (TextUtils.isEmpty(people)) people = "[]";
    List list = jsonDecode(people);
    var name = datas[result];
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      if (item["name"] == name) {
        item["status"] = 1;
      }
    }
    await AppUtils.setConfigString(IConstant.PEOPLE_LIST, jsonEncode(list));
    DataChangeListener.dataChange();
  }

  @override
  void onDataChange() {
    loadData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    try {
      datas.clear();
      String people = await AppUtils.getConfig(IConstant.PEOPLE_LIST, "[]");
      if (TextUtils.isEmpty(people)) people = "[]";
      List list = jsonDecode(people);
      for (var item in list) {
        if (item["status"] == 1) continue;
        datas.add(item["name"]);
        datas.add(item["name"]);
        datas.add(item["name"]);
      }
      datas.shuffle();
    } catch (e) {
      print(e);
    }
  }

  var timer;

  //开始抽奖
  start() async {
    cancelTimer();
    if (datas.isEmpty) {
      Toast.toast(context, msg: "请配置参会人员");
      nextPage(PeoplePage());
      return;
    }
    audioPlayer.play(AssetSource("audios/play.mp3"));
    result = -1;
    step = 1;
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      result = Random().nextInt(datas.length);
      if (result >= datas.length) result = datas.length - 1;
      content_key.currentState?.update();
    });
  }

  //停止
  stop() async {
    audioPlayer.stop();
    cancelTimer();
    showResult();
    step = 0;
    content_key.currentState?.update();
    await updatePeople();
  }

  //展示结果
  showResult() {
    ViewUtils.showPopDialog(
        context,
        SizedBox(
          child: ResultPage(datas[result]),
          height: windowHeight * .8,
        ),
        false);
  }

  cancelTimer() {
    try {
      if (timer != null) timer.cancel();
      timer = null;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: null,
      body: RawKeyboardListener(//键盘事件监听，监听空格键
          onKey: (event) {
            if (IConstant.OPEN_PAGES.last != this) return;
            if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
              if (step == 0)
                start();
              else
                stop();
            }
          },
          focusNode: FocusNode(),
          autofocus: true,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: PartRefreshWidget(
                content_key,
                () => Container(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: Text(
                                "双击切换全屏,空格键或鼠标操作抽奖状态",
                                style: TextStyle(color: Colors.white24),
                              ),
                              margin: EdgeInsets.only(bottom: 10),
                            ),
                          ),
                          Align(
                            child: Image.asset(
                              "assets/icons/dragon.png",
                              width: 400,
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/icons/logo.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "泠泠溪2024",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                    ),
                                  )
                                ],
                              ),
                              margin: EdgeInsets.all(30),
                            ),
                          ),
                          Align(
                            child: step == 0
                                ? InkWell(
                                    onTap: start,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 200, right: 200, top: 50, bottom: 50),
                                      decoration: BoxDecoration(
                                          color: Colors.white24, borderRadius: BorderRadius.circular(6.67), border: Border.all(color: Colors.amber, width: 2)),
                                      child: Text(
                                        "点击开始",
                                        style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: 40),
                                      ),
                                    ),
                                  )
                                : Text(
                                    "${datas[result]}",
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 200, color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 100),
                                  ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffbb2c21), Color(0xffe15618)])),
                    )),
            onDoubleTap: () {
              if (isFull) {
                AppUtils.exitFullscreenMode();
              } else {
                AppUtils.enterFullscreenMode();
              }
            },
            onTap: () {
              if (step == 0) return;
              stop();
            },
          )),
      floatingActionButton: GestureDetector(
        child: LottieBuilder.asset(
          'assets/animates/dragon.json',
          width: 200,
          height: 200,
          repeat: true,
        ),
        onTap: () {
          nextPage(PeoplePage());
        },
      ),
    );
  }

}
