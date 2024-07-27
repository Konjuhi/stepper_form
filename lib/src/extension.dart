import 'package:flutter/cupertino.dart';

extension ScreenHeight on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
}