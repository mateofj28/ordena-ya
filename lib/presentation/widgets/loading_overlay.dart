/*import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // Tu pantalla principal
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Opacidad de fondo
              child: const Center(
                child: CircularProgressIndicator(), // Loader
              ),
            ),
          ),
      ],
    );
  }
}*/

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // Pantalla principal
        if (isLoading)
          Positioned.fill(
            child: ClipRRect(
              // Necesario para BackdropFilter
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // Efecto blur
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/cosmos.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
