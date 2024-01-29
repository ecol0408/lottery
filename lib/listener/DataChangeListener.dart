abstract class DataChangeListener {
  void onDataChange();

  static List<DataChangeListener> _dataChangeListener = [];

  static void attachDataChangeListener(DataChangeListener listener) {
    if (listener == null) return;
    _dataChangeListener.add(listener);
  }

  static void dettachDataChangeListener(DataChangeListener listener) {
    if (listener == null) return;
    _dataChangeListener.remove(listener);
  }

  static dataChange(){
    for (var listener in _dataChangeListener) {
      try {
        if (listener == null) continue;
        listener.onDataChange();
      } catch (e) {}
    }
  }


}
