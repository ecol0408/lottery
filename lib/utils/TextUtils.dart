class TextUtils {
  static bool isEmpty(dynamic str) {
    return str == null || str.toString().isEmpty;
  }

  static bool isNotEmpty(dynamic str) {
    return !isEmpty(str);
  }
}
