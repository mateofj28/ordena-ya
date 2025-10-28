// toggle_button_provider.dart
import 'package:flutter/material.dart';

class ToggleButtonProvider extends ChangeNotifier {
  bool _isPressed = false;

  bool get isPressed => _isPressed;

  void setPressed(bool value) {
    _isPressed = value;
    notifyListeners();
  }
}
