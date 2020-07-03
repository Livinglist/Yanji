import 'package:flutter/material.dart';

class ShiningDot extends StatefulWidget {
  final VoidCallback onTapped;

  ShiningDot({@required this.onTapped});

  @override
  _ShiningDotState createState() => _ShiningDotState();
}

class _ShiningDotState extends State<ShiningDot> with SingleTickerProviderStateMixin {
  final Tween<double> opacityTween = Tween<double>(begin: 0.0, end: 1.0);

  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Opacity(
          opacity: opacityTween.evaluate(controller),
          child: Container(
            child: GestureDetector(onTap: widget.onTapped),
            decoration: BoxDecoration(color: Colors.cyan, shape: BoxShape.circle, border: Border.all(color: Colors.transparent, width: 0.3)),
          ),
        );
      },
    );
  }
}
