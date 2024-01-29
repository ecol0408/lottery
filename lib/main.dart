import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottery/IConstant.dart';
import 'package:lottery/page/MainPage.dart';

void main() {
  loadAudio();
  runApp(const MyApp());
}

loadAudio() {
  try{
    AudioCache audioCache = AudioCache();
    audioCache.loadAsset("audios/fireworks.mp3");
    audioCache.loadAsset("audios/play.mp3");
  }catch(e){}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: IConstant.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}
