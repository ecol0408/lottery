import 'package:flutter/cupertino.dart';

typedef BuildWidget = Widget Function();

class PartRefreshWidget extends StatefulWidget {
  final Key key;
  BuildWidget child;

  PartRefreshWidget(this.key, this.child);

  @override
  State<StatefulWidget> createState() {
    return PartRefreshWidgetState(child);
  }
}

class PartRefreshWidgetState extends State<PartRefreshWidget> {
  BuildWidget child;

  PartRefreshWidgetState(this.child);

  @override
  Widget build(BuildContext context) {
    return child.call();
  }

  void update() {
    setState(() {});
  }
}
