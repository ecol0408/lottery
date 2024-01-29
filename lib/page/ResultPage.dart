import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/IConstant.dart';
import 'package:lottery/page/BaseKeepAliveState.dart';
import 'package:lottie/lottie.dart';

class ResultPage extends StatefulWidget {
  String result;

  ResultPage(this.result);

  @override
  State<StatefulWidget> createState() => ResultPageState();
}

class ResultPageState extends BaseKeepAliveState<ResultPage> {
  @override
  void initState() {
    super.initState();
    audioPlayer.play(AssetSource("audios/fireworks.mp3"));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RawKeyboardListener(
        onKey: (event) {
          if (IConstant.OPEN_PAGES.last != this) return;
          if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
            finish();
          }
        },
        autofocus: true,
        focusNode: FocusNode(),
        child: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffbb2c21), Color(0xffe15618)])),
          child: Stack(
            children: [
              Align(
                child: Row(
                  children: [
                    Expanded(
                        child: LottieBuilder.asset(
                      'assets/animates/fireworks.json',
                      repeat: true,
                    )),
                    Expanded(
                        child: LottieBuilder.asset(
                      'assets/animates/fireworks.json',
                      repeat: true,
                    )),
                    Expanded(
                        child: LottieBuilder.asset(
                      'assets/animates/fireworks.json',
                      repeat: true,
                    )),
                  ],
                ),
                alignment: Alignment.bottomCenter,
              ),
              Align(
                child: Container(
                  child: Text(
                    "恭喜",
                    style: TextStyle(color: Colors.white, fontSize: 100),
                  ),
                ),
                alignment: Alignment.topCenter,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "${widget.result}",
                  style: TextStyle(fontSize: 200, color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 100),
                ),
              ),
              Align(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Container(
                    child: Text(
                      "恭喜",
                      style: TextStyle(color: Colors.white, fontSize: 60),
                    ),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              Align(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    child: Text(
                      "恭喜",
                      style: TextStyle(color: Colors.white, fontSize: 60),
                    ),
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              Align(
                child: Container(
                  child: MaterialButton(
                    onPressed: finish,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    child: Text(
                      "恭喜",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 100),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        ));
  }

}
