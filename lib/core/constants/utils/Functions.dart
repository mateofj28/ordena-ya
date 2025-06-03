import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Functions {
  static void navigateWithSlideUp(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0); // desde abajo
          const end = Offset.zero;
          const curve = Curves.easeOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  static Color getPressedColor(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.light
        ? darken(color, 0.2)
        : lighten(color, 0.2);
  }

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.decimalPattern('es_CO');
    return '\$${formatter.format(amount.truncate())}';
  }

  static String formatCurrencyINT(int amount) {
    final formatter = NumberFormat.decimalPattern('es_CO');
    return '\$${formatter.format(amount)}';
  }
}
