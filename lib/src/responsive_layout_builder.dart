import 'package:flutter/cupertino.dart';

abstract class MainBreakpoints {
  static const double small = 600;
  static const double medium = 1000;
  static const double large = 1440;
}

class ScreenSize {
  ScreenSize.of(BuildContext context) : _context = context;
  final BuildContext _context;

  bool get isSmall =>
      MediaQuery.of(_context).size.width <= MainBreakpoints.small;

  bool get isMedium =>
      MediaQuery.of(_context).size.width <= MainBreakpoints.medium &&
          MediaQuery.of(_context).size.width > MainBreakpoints.small;

  bool get isLarge =>
      MediaQuery.of(_context).size.width <= MainBreakpoints.large &&
          MediaQuery.of(_context).size.width > MainBreakpoints.medium;

  bool get isExtra =>
      MediaQuery.of(_context).size.width > MainBreakpoints.large;

  Size get size => MediaQuery.of(_context).size;

  double get width => MediaQuery.of(_context).size.width;

  double get height => MediaQuery.of(_context).size.height;
}