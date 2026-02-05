import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated flip tag widget with 3D rotation
class FlipTag extends StatefulWidget {
  final String bottomTagText;
  final String footerText;
  final bool flipperConfig;

  const FlipTag({
    super.key,
    required this.bottomTagText,
    required this.footerText,
    required this.flipperConfig,
  });

  @override
  State<FlipTag> createState() => _FlipTagState();
}

class _FlipTagState extends State<FlipTag> {
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    if (widget.flipperConfig) {
      _startFlipping();
    }
  }

  void _startFlipping() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && widget.flipperConfig) {
        setState(() {
          _showFront = !_showFront;
        });
        _startFlipping();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.flipperConfig) {
      // Static display of footer text
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.footerText,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      );
    }

    // Animated flip between bottomTagText and footerText
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final rotateAnim = Tween(begin: math.pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotateAnim,
          child: child,
          builder: (context, child) {
            final isUnder = (ValueKey(_showFront) != child!.key);
            var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
            tilt *= isUnder ? -1.0 : 1.0;
            final value = isUnder
                ? math.min(rotateAnim.value, math.pi / 2)
                : rotateAnim.value;
            return Transform(
              transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      child: _showFront
          ? _buildTagContainer(
              widget.bottomTagText,
              key: const ValueKey(true),
            )
          : _buildTagContainer(
              widget.footerText,
              key: const ValueKey(false),
            ),
    );
  }

  Widget _buildTagContainer(String text, {required Key key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
        ),
      ),
    );
  }
}
