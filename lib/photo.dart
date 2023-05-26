import 'dart:math';
import 'package:flutter/material.dart';

class RotateImage extends StatefulWidget {
  const RotateImage({super.key});

  @override
  State<RotateImage> createState() => _RotateImageState();
}

class _RotateImageState extends State<RotateImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(angle: _controller.value * 2.0 * pi, child: child);
        },
        child: Image.asset('assets/icon.png', height: 200, width: 200));
  }
}
