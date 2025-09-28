import 'dart:async';
import 'package:flutter/material.dart';

class LoadingDotsText extends StatelessWidget {
  final String baseText;
  final Duration interval;

  const LoadingDotsText({
    super.key,
    this.baseText = "Cargando",
    this.interval = const Duration(milliseconds: 500),
  });

  Stream<String> _loadingStream() async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      i = (i + 1) % 4; // 0,1,2,3 → para los puntos
      yield "$baseText${"." * i}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _loadingStream(),
      initialData: baseText,
      builder: (context, snapshot) {
        return Text(
          snapshot.data!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
