import 'package:flutter/material.dart';

class BottomBarVisibilityProvider with ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void show() {
    _isVisible = true;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  void reset() {
    _isVisible = true;
    notifyListeners();
  }
}