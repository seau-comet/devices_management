extension IntX on int {
  /// To convert  0 to false and 1 to true
  /// number should 0 to 1 if not this method will not allow you to use it.
  bool toBool() {
    assert(this >= 0 && this <= 1);
    return this == 0 ? false : true;
  }
}
