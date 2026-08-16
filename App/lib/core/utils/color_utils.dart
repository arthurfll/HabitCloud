import 'package:flutter/material.dart';

/// Parses a "#rrggbb" hex string (the format Core stores in Category.Color) into a Color.
Color hexToColor(String hex) => Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
