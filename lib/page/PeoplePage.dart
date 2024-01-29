import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottery/IConstant.dart';
import 'package:lottery/listener/DataChangeListener.dart';
import 'package:lottery/page/BaseKeepAliveState.dart';
import 'package:lottery/utils/AppUtils.dart';
import 'package:lottery/utils/TextUtils.dart';
import 'package:lottery/utils/ViewUtils.dart';
import 'package:lottery/widget/PartRefreshWidget.dart';

class PeoplePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PeoplePageState();
}

class PeoplePageState extends BaseKeepAliveState<PeoplePage> {
  String str = "";
  GlobalKey<PartRefreshWidgetState> list_key = GlobalKey(), input_key = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    String people = await AppUtils.getConfig(IConstant.PEOPLE_LIST, "[]");
    if (TextUtils.isEmpty(people)) people = "[]";
    List list = jsonDecode(people);
    datas.clear();
    datas.addAll(list);
    list_key.currentState?.update();
  }

  checkInclude(str) {
    for (var item in datas) {
      if (item["name"] == str) return true;
    }
    return false;
  }

  void add() async {
    if (TextUtils.isEmpty(str)) return;
    List<String> list = str.split("\n");
    for (String item in list) {
      if (item.isEmpty) continue;
      if (!checkInclude(item)) {
        datas.add({"name": item, "status": 0});
      }
    }
    str = "";
    input_key.currentState?.update();
    list_key.currentState?.update();
    await AppUtils.setConfigString(IConstant.PEOPLE_LIST, jsonEncode(datas));
    DataChangeListener.dataChange();
  }

  buildItem(idx) {
    var item = datas[idx];
    int status = item["status"];
    return InkWell(
      borderRadius: BorderRadius.circular(6.67),
      child: Container(
        padding: EdgeInsets.only(left: 14.67, right: 14.67),
        decoration: BoxDecoration(color: status == 0 ? Colors.green : Colors.amber, borderRadius: BorderRadius.circular(6.67)),
        alignment: Alignment.center,
        child: Text(
          item["name"] ?? "",
          style: TextStyle(color: Colors.white),
        ),
      ),
      onDoubleTap: () async {
        datas.removeAt(idx);
        await AppUtils.setConfigString(IConstant.PEOPLE_LIST, jsonEncode(datas));
        list_key.currentState?.update();
        DataChangeListener.dataChange();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("参会人员"),
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: false,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {
          if (isFull) {
            AppUtils.exitFullscreenMode();
          } else {
            AppUtils.enterFullscreenMode();
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 30, bottom: 100),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 14, right: 14),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: PartRefreshWidget(
                        input_key,
                        () => TextField(
                              maxLines: 100,
                              controller: ViewUtils.buildTextEditingController(str),
                              decoration: InputDecoration(border: InputBorder.none, hintText: "请输入参会人员姓名，多个换行"),
                              onChanged: (val) {
                                str = val;
                              },
                            )),
                    height: 400,
                    decoration: BoxDecoration(color: Color(0xfff5f5f5), borderRadius: BorderRadius.circular(6.67)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () {
                      add();
                    },
                    elevation: 2,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.67)),
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: Center(
                        child: Text(
                          "新增",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Align(child: Text("参会人员(双击移除)"),alignment: Alignment.centerLeft,),
                  SizedBox(
                    height: 10,
                  ),
                  PartRefreshWidget(
                      list_key,
                      () => GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisExtent: 47, maxCrossAxisExtent: 159, crossAxisSpacing: 10, mainAxisSpacing: 10),
                            itemBuilder: (ctx, idx) => buildItem(idx),
                            itemCount: datas.length,
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
