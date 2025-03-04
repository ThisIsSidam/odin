import 'package:flutter/material.dart';

extension MaterialColorX on MaterialColor {
  List<Color> get shades => <Color>[
        shade50,
        shade100,
        shade200,
        shade300,
        shade400,
        shade500,
        shade600,
        shade700,
        shade800,
        shade900,
      ];
}
